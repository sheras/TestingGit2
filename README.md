# Corrección automática de tareas Java basada en Testing y GitHub

## Instrucciones

1. Obtén un token de autentificación para acceder a tu cuenta GitHub
-
  - Entran en (https://github.com/settings/tokens) 
  - Pulsar el New token. Seleccionar el primer grupo (repo)
  - Copiar y pegar en docker-compose.yml en OAUTH_TOKEN (y en aceptar_invitaciones/docer-compose.yml)

¡CUIDADO! Este token no puede ser publicado.

2. Introduce en el fichero repositorios.txt la lista de repositorios GiHub y nombre de los alumnos.

EJEMPLO:
```java
RubenPardo/CatalogoAstronomico|Ruben Pardo
jjhr7/catalogo_astronomico|Jonathan Javier Hernandez

```
NOTA: Insertar una línea en blanco al final

3. Acepta todas las invitaciones a repositorios pendientes:
```shell
cd aceptar_invitaciones
docker-compose up --build
cd ..
```

4. Lanza la aplicación
```shell
docker-compose up --build
ó
ejecutar.bat
```

5. Estudiar la salida en carpeta salidas
