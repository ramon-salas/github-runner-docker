# GITHUB RUNNER DOCKER
## Creación de imagén Docker para la ejecución CI/CD

He creado este proyecto para poder subir en una imagen de Docker los elementos necesarios para correr un runner de github y así poder gestionar el CI/CD de las aplicaciones

## Pasos para la generación de la imagen y contenedor Docker

* Copiar todos los archivos a un servidor o maquina donde este instalado el motor de Docker
* Desde donde esta el archivo Dockerfile ejecutar el comando

```console
docker build -t github-runner:v1 .
```
* Una vez creada la imagen entonces se puede generar el contendor. Pero antes de generar el comando del contenedor se tienen que tener en cuenta algunas cosas:
    * Se necesta tener en la maquina host la instalación del JDK con el cual va a compilar sus proyectos
    * Se necesita tener en la maquina host la instalación de maven con el cual va a compilar sus proyectos
    * Se necesita tener la URL del proyecto en GitHub
    * Se necesita tener el HASH para crear el Runner
* Una vez tenido en cuenta todo esto entonces se podrá ejecutar el siguiente comando:
```console
docker run --restart always -d -v $JAVA_PATH:/jdk -v $MAVEN_PATH:/maven -e MAVEN_HOME=/maven -e JAVA_HOME=/jdk -e GITHUB_REPO_URL=$URL_REPO -e GITHUB_TOKEN=$HASH --name sajiro-bmv-recovery-runner github-runner:v1
```
Reemplazar los siguiente valores:

JAVA_PATH: El path absoluto en donde esta instalado el java en su maquina host

MAVEN_PATH El path absoluto en donde se instalado el maven en su maquina host

URL_REPO: La URL de su repo

HASH: El hash proporcionado por github actions cuando se crea un self runner

*Como dato importante, tanto el nombre de la imagen (github-runner:v1) como el nombre del contenedor (sajiro-bmv-recovery-runner) no son obligatorios y puede reemplazarlos con el nombre que mejor le acomode a su proyecto.*