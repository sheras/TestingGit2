import os
import requests

OAUTH_TOKEN = os.environ['OAUTH_TOKEN']

headers = {"Authorization": f"token {OAUTH_TOKEN}"}

invitations = requests.get('https://api.github.com/user/repository_invitations', headers=headers)

print(f"Respuesta: {invitations.status_code}")


for invitation in invitations.json():
    id = invitation["id"]
    name = invitation["repository"]["full_name"]
    print(f"Aceptando invitación para repositorio {name}")
    res = requests.patch(f'https://api.github.com/user/repository_invitations/{id}', headers=headers)
    print(f"El resultado ha sido {res.status_code}")