# arquitecturaDeMicroprocesadores
Espacio de trabajo para la materia Arquitectura de Microprocesadores de la Especialización de Sistemas Embebidos de FIUBA

## VSCode: instrucciones de depuración con EDU-CIAA-NXP
**Nota: únicamente probado en Ubuntu 20.04**
- Instalar [Visual Studio Code](https://code.visualstudio.com/)
- Agregar el Plugin [Cortex Debug](https://marketplace.visualstudio.com/items?itemName=marus25.cortex-debug)
- En el Makefile del repositorio, actualizar los directorios de las herramientas de programación y depuración en funcion de dónde se tengan instaladas. Específicamente las siguientes dos herramientas:
```mak
...
CROSS=arm-none-eabi-
...
OOCD=openocd
...
```
Si las herramientas fueron instaladas siguiendo los pasos de [Firmware V3](https://github.com/epernia/firmware_v3) o similar, posiblemente el directorio en el que se encuentren dichas herramientas sea:
```
/home/<username>/CIAA/tools/
```
En cuyo caso las lineas pertinentes del makefile quedarían de la siguiente manera
```mak
...
CROSS=/home/<username>/CIAA/tools/gcc-arm-embedded/bin/arm-none-eabi-
...
OOCD=/home/<username>/CIAA/tools/openocd/bin/openocd
...
```
- Crear un archivo `launch.json` en la carpeta `.vscode` en el directorio raíz
```sh
mkdir -p .vscode && cd .vscode # Ignorar si la carpeta ya existe.
touch launch.json # Ignorar si el archivo ya existe
```
Luego copiar la siguiente configuración en el archivo `launch.json` creado (reemplazando los directorios donde corresponda).
```json
{
    "version": "0.2.0",
    "configurations": [     
        {
            "name": "EDU-CIAA-Debug",
            "cwd": "${workspaceRoot}",
            "executable": "${workspaceRoot}/out/arquitecturaDeMicroprocesadores.elf",
            "request": "launch",
            "type": "cortex-debug",
            "servertype": "openocd",
            "serverpath": "/home/<username>/CIAA/tools/openocd/bin/openocd",
            "configFiles": [
                "${workspaceRoot}/lib/ciaa-nxp.cfg"
            ],
        }
    ]
}
```
- Correr desde la terminal el siguiente comando para para compilar la aplicación (conectar la EDU-CIAA a la PC previamente):
```
make program
```
Nota: se puede crear una Task de Vscode para que automáticamente compile el binario cada vez que queramos debuggear y no tener que hacerlo manualmente.
- Finalmente, posicionarse en el archivo de código fuente a depurar (`main.c` por ejemplo) y presionar `F5`. 
- Revisar que en la columna de la izquierda (menu de depuración) se pueden observar los registros del microcontrolador, pero la ventana se encuentra colapsada por defecto (se expande haciendo click sobre ella).



