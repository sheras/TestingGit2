echo "-----------------------"
echo "Clonando solución"
echo "-----------------------"

git clone https://$OAUTH_TOKEN:x-oauth-basic@github.com/jesus-tomas-girones/catalogo_astronomico_resuelto.git resuelto
echo '\ntest{useTestNG();testLogging {events "passed", "skipped", "failed"}}\n' >> /build/resuelto/app/build.gradle
rm /salidas/Comun

while read LINE <&3; do
  cd /build
  rm -r /build/clonado
  name=$(echo $LINE | cut -d'|' -f2 | sed 's/.$//')
  repo=$(echo $LINE | cut -d'|' -f1)

  echo "-----------------------"
  echo "Clonando para $name"
  echo "-----------------------"

  echo Empezando con el repositorio $repo | tee "/salidas/$name"

  git clone https://$OAUTH_TOKEN:x-oauth-basic@github.com/$repo.git clonado

  if [ $? -ne 0 ]; then
    echo "No podemos clonar $repo" | tee -a "/salidas/$name"
    echo $name No podemos clonar | tee -a "/salidas/Comun"
    continue
  fi

  echo "Copiando"

  rm -r /build/resuelto/app/src/main/java/com/example/catalogoastronomico/*
  cp -r /build/clonado/catalogo/src/main/java/com/example/catalogoastronomico/* /build/resuelto/app/src/main/java/com/example/catalogoastronomico

  cd /build/resuelto

 # echo '\ntest{useTestNG();testLogging {events "passed", "skipped", "failed"}}\n' >> catalogo/build.gradle

  echo "-----------------------"
  echo "Ejecutando tests"
  echo "-----------------------"

  sh gradlew test > resultados 2>&1

  grep "Gradle suite > Gradle test >" resultados > resultados_filtrado
  cat resultados | tee -a "/salidas/$name"
  echo Tests pasados: $(grep PASSED resultados_filtrado | wc -l) | tee -a "/salidas/$name"
  echo Tests fallidos: $(grep FAILED resultados_filtrado | wc -l) | tee -a "/salidas/$name"

  
  echo $name Tests pasados: $(grep PASSED resultados_filtrado | wc -l) | tee -a "/salidas/Comun"
  echo $name Tests fallidos: $(grep FAILED resultados_filtrado | wc -l) | tee -a "/salidas/Comun"

  echo "-----------------------"
  echo "Limpiando resultados"
  echo "-----------------------"

  cd /build
done 3< /repositorios.txt
