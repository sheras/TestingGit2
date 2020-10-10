* Preparar imagen docker con las dependencias (base: https://hub.docker.com/_/gradle)
  - crear fichero dockerfile
  - 6.6-jdk  

* Generar un Personal Access Token (Obtener codigo de OAuth para que la aplicación pueda acceder a nuestro GitHub) ¡CUIDADO! Este token no puede ser publicado.
  - Entran en (https://github.com/settings/tokens) 
  - Pulsar el New token. Seleccionar el primer grupo (repo)
  - Copiar y pegar en docker-compose.yml en OAUTH_TOKEN

* Aceptar la invitación al repositorio (https://developer.github.com/v3/repos/invitations/#list-repository-invitations)

* Descargar el repositorio (git clone https://c304f2bce7a0ce60b07f914c1b291a715efa60fd:x-oauth-basic@github.com/jesus-tomas-girones/catalogo_astronomico_resuelto.git clonado)
* Sobrescribir los tests (opcional)
* Cambiar configuracion de gradle:
```
test {
    useTestNG()
    testLogging {
        events "passed", "skipped", "failed"
    }
}
```

* Ejecutar los tests
* Parsear la salida

## Para más de un alumno al mismo tiempo
* Leer la lista de repositorios
* Borrar la carpeta descargada (opcional)
* Escribir los resultados en un fichero de texto


# Por hacer
* Aceptar la invitación al repositorio (https://developer.github.com/v3/repos/invitations/#list-repository-invitations). También se podría aceptar a mano
* Sobrescribir los tests (opcional)
* Parsear la salida
* Usar solo el nombre del usuario en repositorios.txt y añadir automáticamente "repositorio automático"