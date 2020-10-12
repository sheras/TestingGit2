#!/usr/bin/python3

import os
import shutil
import subprocess

OAUTH_TOKEN = os.environ['OAUTH_TOKEN']

clone_folder = "clonado"


def execute_command(command: str) -> (str, int):
    p = subprocess.Popen(command, stdout=subprocess.PIPE, shell=True)
    p.wait()
    text = p.stdout.read()
    code = p.returncode
    return (text, code)


print("Empezando")

with open("/repositorios.txt", "r") as f:
    for line in f:
        repo, user = line.strip().split("|")
        print(f'Repository "{repo}" belongs to user "{user}"', flush=True)
        text, code = execute_command(
            f'git clone https://{OAUTH_TOKEN}:x-oauth-basic@github.com/{repo} {clone_folder}')
        if code is not 0:
            print(f"Could not clone repository for user {user}", flush=True)
            continue
        

        os.chdir(clone_folder)

        os.system(
            '''echo '\ntest{useTestNG();testLogging {events "passed", "skipped", "failed"}}\n' >> app/build.gradle''')
        
        print("Ejecutando tests", flush=True)

        os.system('sh gradlew test | grep "Gradle suite > Gradle test >" > resultados')

        print("Procesando tests", flush=True)

        #text, code = execute_command('gradlew test')
        with open("resultados", "r") as resultados:
            pasados = 0
            fallidos = 0
            for res_line in resultados:
                print(res_line.strip())
                if "PASSED" in res_line:
                    pasados += 1
                if "FAILED" in res_line:
                    fallidos += 1

            with open(f"/{user}", "w") as salida_ind:
                salida_ind.write(f"Tests fallidos: {fallidos}")
                salida_ind.write(f"Tests pasados: {pasados}")

        os.chdir("../")
        shutil.rmtree(clone_folder)
