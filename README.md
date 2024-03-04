# GITHUB RUNNER DOCKER
## Creación de imagén Docker para la ejecución CI/CD

He creado este proyecto para poder subir en una imagen de Docker los elementos necesarios para correr un runner de github y así poder gestionar el CI/CD de las aplicaciones

## Pasos para la generación de la imagen y contenedor Docker

* Copiar todos los archivos a un servidor o maquina donde este instalado el motor de Docker
* Generar el archivo llamado initRunner.sh en el servidor LINUX al mimso nivel en donde se copiaron los archivos de este repositorio. El contenido del script de shell es el siguiente
```bash
#!/bin/bash

cd actions-runner
if [ ! -f created.log ]
then
	./config.sh --url $GITHUB_REPO_URL --token $GITHUB_TOKEN
fi
echo "created" > created.log
./run.sh
```
* Generar las llaves del ssh en el servidor, esto se hace ejecutando el comando
```bash
$ ssh-keygen -t rsa
```
Se recomienda no poner contraseña a la llave ya que esta al ser ejecutada dentro del contenedor es imposible ingresar esta contraseña sin utilizar ciertas modificaciones al contenedor

Ya que tenga sus llaves, estarán ubicadas en ~/.ssh

Copie el contenido del archivo id_rsa.pub y dirijase a GitHub

En los settings de su cuenta en SSH and GPG keys de clic en el botón New SSH key que esta del lado derecho de su pantalla en la parte superior

Agregue un nombre y pegue el contenido antes copiado del archivo id_rsa.pub, con esto ya podrá hacer modificaciones desde el contenedor a sus repositorios

* Copie el archivo ~/.ssh/id_rsa a la carpeta donde esta el archivo Dockerfile. Es importante que lo deje con el mismo nombre
* Desde donde esta el archivo Dockerfile ejecutar el comando
```console
$ docker build -t github-runner:v1 .
```
* Una vez creada la imagen entonces se puede generar el contendor. Pero antes de generar el comando del contenedor se tienen que tener en cuenta algunas cosas:
    * Se necesta tener en la maquina host la instalación del JDK con el cual va a compilar sus proyectos
    * Se necesita tener en la maquina host la instalación de maven con el cual va a compilar sus proyectos
    * Se necesita tener la URL del proyecto en GitHub
    * Se necesita tener el HASH para crear el Runner
* Una vez tenido en cuenta todo esto entonces se podrá ejecutar el siguiente comando:
```console
$ docker run --restart always -d -v $JAVA_PATH:/jdk -v $MAVEN_PATH:/maven -e MAVEN_HOME=/maven -e JAVA_HOME=/jdk -e GITHUB_REPO_URL=$URL_REPO -e GITHUB_TOKEN=$HASH --name sajiro-bmv-recovery-runner github-runner:v1
```
Reemplazar los siguiente valores:

JAVA_PATH: El path absoluto en donde esta instalado el java en su maquina host

MAVEN_PATH El path absoluto en donde se instalado el maven en su maquina host

URL_REPO: La URL de su repo

HASH: El hash proporcionado por github actions cuando se crea un self runner

*Como dato importante, tanto el nombre de la imagen (github-runner:v1) como el nombre del contenedor (sajiro-bmv-recovery-runner) no son obligatorios y puede reemplazarlos con el nombre que mejor le acomode a su proyecto.*
* Como punto adicional se recomienda crear un shell de script para la creación del contenedor apartir de la imagen creada con ayuda de este repositorio, se sugiere el siguiente script
```bash
#!/bin/bash

APP_MODE_SYNTAX="Parametros requeridos: 1-URL GitHub Repo (Ej.https://github.com/ramon-salas/sajiro-app-parent), 2-SSH URL GitHub Repo(Ej.git@github.com:ramon-salas/sajiro-app-parent.git), 3-HASH GitHub (Ej.AEBAFHNEH4OQKEKOPWEFOYDF4HXWI), 4-Nombre del Contenedor (Ej.sajiro-bmv-recovery-runner)"

if [ $# -le 0 -o $# -gt 4 ]
then
  echo $APP_MODE_SYNTAX
  exit -1
fi

JAVA_PATH=/home/sajiro/jdk/amazon-corretto-17.0.10.8.1-linux-x64/
MAVEN_PATH=/home/sajiro/apps/apache-maven-3.9.6/

docker run --restart always -d -v $JAVA_PATH:/jdk -v $MAVEN_PATH:/maven -e MAVEN_HOME=/maven -e JAVA_HOME=/jdk -e GITHUB_REPO_URL=$1 -e GITHUB_TOKEN=$3 -e GITHUB_SSH_REPO_URL=$2 --name $4 github-runner:v1
```
Un ejemplo de ejcución de este script sería el siguiente:

```console
$ ./create.sh https://github.com/user/repo git@github.com:user/user_repo.git AEBAFHNEH4ASKASDPXDDDSSSDDDRRR repo-runner
```