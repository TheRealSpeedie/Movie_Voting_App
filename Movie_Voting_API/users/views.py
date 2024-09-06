from django.http import HttpResponseBadRequest, HttpResponseRedirect, JsonResponse
from django.shortcuts import redirect
from . import constants
from django.contrib.auth.models import User
import requests

from django.contrib.auth import logout, login

def home(request):
    if not request.user.is_authenticated:
        return HttpResponseRedirect(constants.GOOGLE_LOGIN_REDIRECT_URI)
    else:
        return JsonResponse({"message": "Already logged in"})


def google_callback(request):
    if 'error' in request.GET:
        return redirect('admin:index')

    if 'code' in request.GET:
        code = request.GET.get('code')
        token_endpoint = 'https://oauth2.googleapis.com/token'
        token_data = {
            'code': code,
            'client_id': constants.GOOGLE_CLIENT_ID,
            'client_secret': constants.GOOGLE_CLIENT_SECRET,
            'redirect_uri': constants.GOOGLE_REDIRECT_URI,
            'grant_type': 'authorization_code'
        }
        response = requests.post(token_endpoint, data=token_data)
        token_json = response.json()
        access_token = token_json.get('access_token')
        
        if access_token:
            userinfo_endpoint = 'https://www.googleapis.com/oauth2/v1/userinfo'
            headers = {'Authorization': f'Bearer {access_token}'}
            userinfo_response = requests.get(userinfo_endpoint, headers=headers)
            userinfo_json = userinfo_response.json()
            user_email = userinfo_json.get('email')
            existing_user = User.objects.filter(email=user_email).first()
            
            if existing_user:
                login(request, user=existing_user)
                return JsonResponse({"Message": "User logged in", "Email": existing_user.email})
            else:
                new_user = User.objects.create_user(username=user_email, email=user_email)
                new_user.backend = 'django.contrib.auth.backends.ModelBackend'
                login(request, user=new_user)
                return JsonResponse({"Message": "User registered and logged in", "Email": new_user.email})
        
        return HttpResponseBadRequest("Fehler beim Login")
    
    return redirect('admin:index')



def logout_view(request):
    logout(request)
    return JsonResponse({"message": "User logged out"})