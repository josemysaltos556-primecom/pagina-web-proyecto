  Funcion coincide <- CoincideLugar(clave, nombre, categoria, identificador, codigoQR)
      Definir coincide Como Logico
      coincide <- Minusculas(clave) = Minusculas(nombre) O Minusculas(clave) = Minusculas(categoria) O Minusculas(clave) = Minusculas(identificador) O Minusculas(clave) = Minusculas(codigoQR)
  FinFuncion
  Funcion total <- SumarDistancias(tramoUno, tramoDos)
      Definir total Como Entero
      total <- tramoUno + tramoDos
  FinFuncion
  SubProceso MostrarMenu
      Escribir "======================================="
      Escribir " MAPA INTERACTIVO UTMACH"
      Escribir "======================================="
      Escribir "1. Consultar lugares del campus"
      Escribir "2. Buscar facultad, oficina o servicio"
      Escribir "3. Mostrar informacion de un lugar"
      Escribir "4. Consultar ruta entre dos puntos"
      Escribir "5. Consultar distancias entre lugares"
      Escribir "6. Simular lectura de codigo QR"
      Escribir "7. Finalizar el programa"
  FinSubProceso
  SubProceso MostrarLugar(nombre, categoria, descripcion, identificador, codigoQR)
      Escribir "ID: ", identificador
      Escribir "Lugar: ", nombre
      Escribir "Categoria: ", categoria
      Escribir "Descripcion: ", descripcion
      Escribir "QR simulado: ", codigoQR
  FinSubProceso
  Algoritmo Mapa_Interactivo_UTMACH
      // DECLARACION DE VARIABLES
      Definir nombres, categorias, descripciones Como Cadena
      Definir identificadores, codigosQR Como Cadena
      Definir clave Como Cadena
      Definir conexiones Como Entero
      Definir opcionMenu, i, j Como Entero
      Definir origen, destino, posicion, intermedio Como Entero
      Definir distanciaDirecta, tramoUno, tramoDos Como Entero
      Definir distanciaTotal, distanciaCandidata Como Entero
      // ARREGLOS Y MATRIZ
      Dimension nombres[6]
      Dimension categorias[6]
    Dimension descripciones[6]
    Dimension identificadores[6]
    Dimension codigosQR[6]
    Dimension conexiones[6,6]
    // INVENTARIO DE LUGARES SIMULADOS
    nombres[1] <- "Entrada principal"
    nombres[2] <- "Biblioteca"
    nombres[3] <- "Facultad"
    nombres[4] <- "Laboratorios"
    nombres[5] <- "Area administrativa"
    categorias[1] <- "Acceso"
    categorias[2] <- "Servicio"
    categorias[3] <- "Academico"
    categorias[4] <- "Academico"
    categorias[5] <- "Oficina"
    descripciones[1] <- "Punto de ingreso simulado"
    descripciones[2] <- "Consulta de material bibliografico"
    descripciones[3] <- "Zona de aulas simulada"
    descripciones[4] <- "Espacios de practica simulados"
    descripciones[5] <- "Tramites administrativos simulados"
    Para i <- 1 Hasta 5 Hacer
        identificadores[i] <- ConvertirATexto(i)
    FinPara
    codigosQR[1] <- "QR-ENT"
    codigosQR[2] <- "QR-BIB"
    codigosQR[3] <- "QR-FAC"
    codigosQR[4] <- "QR-LAB"
    codigosQR[5] <- "QR-ADM"
    // MATRIZ DE CONEXIONES SIMULADAS
    Para i <- 1 Hasta 5 Hacer
        Para j <- 1 Hasta 5 Hacer
            conexiones[i,j] <- 0
        FinPara
    FinPara
    conexiones[1,2] <- 2
    conexiones[2,1] <- 2
    conexiones[1,3] <- 4
    conexiones[3,1] <- 4
    conexiones[2,3] <- 3
    conexiones[3,2] <- 3
    conexiones[2,5] <- 6
    conexiones[5,2] <- 6
    conexiones[3,4] <- 2
    conexiones[4,3] <- 2
    conexiones[4,5] <- 4
    conexiones[5,4] <- 4
    // MENU PRINCIPAL
    opcionMenu <- 0
    Mientras opcionMenu <> 7 Hacer
        MostrarMenu
        Escribir "Seleccione una opcion (1 a 7):"
        Leer opcionMenu
        Segun opcionMenu Hacer
            1:
                Escribir "--- LUGARES DEL CAMPUS ---"
                Para i <- 1 Hasta 5 Hacer
                         Escribir i, ". ", nombres[i], " - ", categorias[i]
                     FinPara
               2:
                Escribir "Ingrese nombre, categoria, ID o codigo QR:"
                Leer clave
                posicion <- 0
                Para i <- 1 Hasta 5 Hacer
                    Si CoincideLugar(clave, nombres[i], categorias[i], identificadores[i], codigosQR[i]) Entonces
                        Si posicion = 0 Entonces
                             posicion <- i
                        FinSi
                    FinSi
                FinPara
                Si posicion > 0 Entonces
                    MostrarLugar(nombres[posicion], categorias[posicion], descripciones[posicion], identificadores[posicion], codigosQR[posicion])
                SiNo
                    Escribir "No se encontro el lugar solicitado."
                FinSi
            3:
                Repetir
                    Escribir "Ingrese ID del lugar (1 a 5):"
                    Leer posicion
                Hasta Que posicion >= 1 Y posicion <= 5
                MostrarLugar(nombres[posicion], categorias[posicion], descripciones[posicion], identificadores[posicion], codigosQR[posicion])
            4:
                Repetir
                    Escribir "Ingrese el origen (1 a 5):"
                    Leer origen
                Hasta Que origen >= 1 Y origen <= 5
                Repetir
                    Escribir "Ingrese el destino (1 a 5):"
                    Leer destino
                Hasta Que destino >= 1 Y destino <= 5
                Si origen = destino Entonces
                    Escribir "Origen y destino son el mismo lugar."
                FinSi
                Si origen <> destino Entonces
                    distanciaDirecta <- conexiones[origen,destino]
                    distanciaTotal <- 9999
                    intermedio <- 0
                    Si distanciaDirecta > 0 Entonces
                        distanciaTotal <- distanciaDirecta
                    FinSi
                    Para i <- 1 Hasta 5 Hacer
                        Si i <> origen Y i <> destino Entonces
                             tramoUno <- conexiones[origen,i]
                             tramoDos <- conexiones[i,destino]
                             Si tramoUno > 0 Y tramoDos > 0 Entonces
                                 distanciaCandidata <- SumarDistancias(tramoUno, tramoDos)
                                 Si distanciaCandidata < distanciaTotal Entonces
                                      distanciaTotal <- distanciaCandidata
                                      intermedio <- i
                                 FinSi
                                  FinSi
                             FinSi
                         FinPara
                         Si distanciaTotal = 9999 Entonces
                             Escribir "Sin ruta directa ni ruta de una parada."
                         SiNo
                             Escribir "Origen: ", nombres[origen]
                             Si intermedio > 0 Entonces
                                  Escribir "Pasar por: ", nombres[intermedio]
                             FinSi
                             Escribir "Destino: ", nombres[destino]
                             Escribir "Distancia simulada: ", distanciaTotal, " unidades"
                         FinSi
                     FinSi
               5:
                     Repetir
                         Escribir "Ingrese ID del lugar de origen (1 a 5):"
                         Leer origen
                     Hasta Que origen >= 1 Y origen <= 5
                     Escribir "--- DISTANCIAS DESDE ", nombres[origen], " ---"
                     Para i <- 1 Hasta 5 Hacer
                         Si i <> origen Entonces
                             distanciaDirecta <- conexiones[origen,i]
                             Si distanciaDirecta > 0 Entonces
                                  Escribir nombres[i], ": ", distanciaDirecta, " unidades ficticias"
                             SiNo
                                  Escribir nombres[i], ": sin conexion directa"
                             FinSi
                         FinSi
                     FinPara
               6:
                Escribir "Ingrese codigo QR (ejemplo QR-BIB):"
                Leer clave
                posicion <- 0
                Para i <- 1 Hasta 5 Hacer
                    Si Minusculas(clave) = Minusculas(codigosQR[i]) Entonces
                        posicion <- i
                    FinSi
                FinPara
                Si posicion > 0 Entonces
                    Escribir "Codigo QR reconocido."
                    MostrarLugar(nombres[posicion], categorias[posicion], descripciones[posicion], identificadores[posicion], codigosQR[posicion])
                SiNo
                    Escribir "Codigo QR no registrado."
                FinSi
            7:
                Escribir "Programa finalizado correctamente."
            De Otro Modo:
                Escribir "Opcion invalida. Elija de 1 a 7."
        FinSegun
    FinMientras
 FinAlgoritmo