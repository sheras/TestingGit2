while read LINE <&3; do
  name=$(echo $LINE | cut -d'|' -f2 | sed 's/.$//')
  repo=$(echo $LINE | cut -d'|' -f1)

  echo "-----------------------"
  echo "Clonando para $name"
  echo "-----------------------"

  git clone https://$OAUTH_TOKEN:x-oauth-basic@github.com/$repo clonado
  cd clonado

  echo '\ntest{useTestNG();testLogging {events "passed", "skipped", "failed"}}\n' >> app/build.gradle

  echo "-----------------------"
  echo "Ejecutando tests"
  echo "-----------------------"

  sh gradlew test | grep "Gradle suite > Gradle test >" > resultados

  cat resultados | tee "/salidas/$name"
  echo Tests pasados: $(grep PASSED resultados | wc -l) | tee -a "/salidas/$name"
  echo Tests fallidos: $(grep FAILED resultados | wc -l) | tee -a "/salidas/$name"

  echo "-----------------------"
  echo "Limpiando resultados"
  echo "-----------------------"

  cd /build
  rm -r clonado
done 3< /repositorios.txt
