echo "-----------------------"
echo "Clonando solución"
echo "-----------------------"

rm -r /build/resuelto
git clone https://$OAUTH_TOKEN:x-oauth-basic@github.com/jesus-tomas-girones/catalogo_astronomico_resuelto.git resuelto
echo '\ntest{useTestNG();testLogging {events "passed", "skipped", "failed"}}\n' >> /build/resuelto/app/build.gradle
rm /salidas/Comun

#echo '\n' >> /repositorios.txt #Mejor no poner, dado que lo añade en cada ejecución 

while read LINE <&3; do
  cd /build
  rm -r /build/clonado
  repo=$(echo $LINE | cut -d'|' -f2| sed 's/.$//')
  name=$(echo $LINE | cut -d'|' -f1)
  
  echo "-----------------------"
  echo "Clonando para $name"
  echo "-----------------------"

  echo Empezando con el repositorio $repo | tee "/salidas/$name"

  git clone https://$OAUTH_TOKEN:x-oauth-basic@github.com/$repo.git clonado

  if [ $? -ne 0 ]; then
    echo "No podemos clonar $repo" | tee -a "/salidas/$name"
    echo $name -- No podemos clonar | tee -a "/salidas/Comun"
    continue
  fi

  cd /build/clonado

  LAST_COMMIT=$(git log -1 --pretty=format:'%an')

  if [ "$LAST_COMMIT" = "Stella Heras" ]; then  #Si el úlimo push es del profesor
    echo "No ha hecho commit" | tee -a "/salidas/$name"
    echo $name -- No ha hecho commit | tee -a "/salidas/Comun"
    continue
  fi

  if [ "$LAST_COMMIT" = "Jesus Tomas Girones" ]; then  #Si el úlimo push es del profesor
    echo "No ha hecho commit" | tee -a "/salidas/$name"
    echo $name -- No ha hecho commit | tee -a "/salidas/Comun"
    continue
  fi

  if [ "$LAST_COMMIT" = "" ]; then  #Si no hay ultimo push
    echo "No hay nada en el repositorio" | tee -a "/salidas/$name"
    echo $name -- No hay nada en el repositorio | tee -a "/salidas/Comun"
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

  sh gradlew clean test > resultados 2>&1

  grep "Gradle suite > Gradle test >" resultados > resultados_filtrado
  cat resultados | tee -a "/salidas/$name"
  echo Tests pasados: $(grep PASSED resultados_filtrado | wc -l) | tee -a "/salidas/$name"
  echo Tests fallidos: $(grep FAILED resultados_filtrado | wc -l) | tee -a "/salidas/$name"

  
  #echo $name Tests pasados: $(grep PASSED resultados_filtrado | wc -l) | tee -a "/salidas/Comun"
  #echo $name Tests fallidos: $(grep FAILED resultados_filtrado | wc -l) | tee -a "/salidas/Comun"
  echo $name -- Tests pasados/fallidos: $(grep PASSED resultados_filtrado | wc -l) / $(grep FAILED resultados_filtrado | wc -l) | tee -a "/salidas/Comun"


  echo "-----------------------"
  echo "Limpiando resultados"
  echo "-----------------------"

  cd /build
done 3< /repositorios.txt
