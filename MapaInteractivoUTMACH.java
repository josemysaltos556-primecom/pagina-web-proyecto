package utmach;
import java.util.Scanner;

public class MapaInteractivoUTMACH {
    static boolean coincideLugar(String clave, String nombre,
            String categoria, String identificador, String codigoQR) {
        return clave.equalsIgnoreCase(nombre) || clave.equalsIgnoreCase(categoria)
                || clave.equalsIgnoreCase(identificador) || clave.equalsIgnoreCase(codigoQR);
    }
    static int sumarDistancias(int tramoUno, int tramoDos) {
        return tramoUno + tramoDos;
    }
    static void mostrarMenu() {
        System.out.println("=======================================");
        System.out.println(" MAPA INTERACTIVO UTMACH");
        System.out.println("1. Consultar lugares del campus");
        System.out.println("2. Buscar facultad, oficina o servicio");
        System.out.println("3. Mostrar informacion de un lugar");
        System.out.println("4. Consultar ruta entre dos puntos");
        System.out.println("5. Consultar distancias entre lugares");
        System.out.println("6. Simular lectura de codigo QR");
        System.out.println("7. Finalizar el programa");
    }
    static void mostrarLugar(String nombre, String categoria, String descripcion,
            String identificador, String codigoQR) {
        System.out.println("ID: " + identificador);
        System.out.println("Lugar: " + nombre);
        System.out.println("Categoria: " + categoria);
        System.out.println("Descripcion: " + descripcion);
        System.out.println("QR simulado: " + codigoQR);
    }
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        // Indice 0 reservado para conservar los ID del Avance 3.
        String[] nombres = {"", "Entrada principal", "Biblioteca", "Facultad",
            "Laboratorios", "Area administrativa"};
        String[] categorias = {"", "Acceso", "Servicio", "Academico", "Academico", "Oficina"};
        String[] descripciones = {"", "Punto de ingreso simulado",
            "Consulta de material bibliografico", "Zona de aulas simulada",
            "Espacios de practica simulados", "Tramites administrativos simulados"};
        String[] identificadores = new String[6];
        String[] codigosQR = {"", "QR-ENT", "QR-BIB", "QR-FAC", "QR-LAB", "QR-ADM"};
        int[][] conexiones = new int[6][6];
        int opcionMenu = 0, i, origen, destino, posicion, intermedio;
        int distanciaDirecta, tramoUno, tramoDos, distanciaTotal, distanciaCandidata;
        String clave;
        // for: inicializacion de identificadores; matriz inicializada en cero por Java.
        for (i = 1; i <= 5; i++) identificadores[i] = Integer.toString(i);
        conexiones[1][2] = conexiones[2][1] = 2;
        conexiones[1][3] = conexiones[3][1] = 4;
        conexiones[2][3] = conexiones[3][2] = 3;
        conexiones[2][5] = conexiones[5][2] = 6;
        conexiones[3][4] = conexiones[4][3] = 2;
        conexiones[4][5] = conexiones[5][4] = 4;
        // while: mantener el menu activo; switch: elegir operacion.
        while (opcionMenu != 7) {
            mostrarMenu();
            System.out.println("Seleccione una opcion (1 a 7):");
            opcionMenu = leerEntero(sc);
            switch (opcionMenu) {
                case 1:
                    System.out.println("--- LUGARES DEL CAMPUS ---");
                    for (i = 1; i <= 5; i++)
                        System.out.println(i + ". " + nombres[i] + " - " + categorias[i]);
                    break;
                case 2:
                    System.out.println("Ingrese nombre, categoria, ID o codigo QR:");
                    clave = sc.nextLine();
                    posicion = 0;
                    for (i = 1; i <= 5; i++) {
                        if (coincideLugar(clave, nombres[i], categorias[i], identificadores[i], codigosQR[i])) {
                            if (posicion == 0) posicion = i;
                        }
                    }
                    // if-else: resultado de busqueda.
                    if (posicion > 0) mostrarLugar(nombres[posicion], categorias[posicion],
                            descripciones[posicion], identificadores[posicion], codigosQR[posicion]);
                    else System.out.println("No se encontro el lugar solicitado.");
                    break;
                case 3:
                    do {
                        System.out.println("Ingrese ID del lugar (1 a 5):");
                        posicion = leerEntero(sc);
                    } while (posicion < 1 || posicion > 5);
                    mostrarLugar(nombres[posicion], categorias[posicion], descripciones[posicion],
                            identificadores[posicion], codigosQR[posicion]);
                    break;
                case 4:
                    // do-while: repetir hasta obtener identificadores validos.
                    do {
                        System.out.println("Ingrese el origen (1 a 5):");
                        origen = leerEntero(sc);
                    } while (origen < 1 || origen > 5);
                    do {
                        System.out.println("Ingrese el destino (1 a 5):");
                        destino = leerEntero(sc);
                    } while (destino < 1 || destino > 5);
                    // if simple: evitar rutas al mismo lugar.
                    if (origen == destino) System.out.println("Origen y destino son el mismo lugar.");
                    if (origen != destino) {
                        distanciaDirecta = conexiones[origen][destino];
                        distanciaTotal = 9999;
                        intermedio = 0;
                        if (distanciaDirecta > 0) distanciaTotal = distanciaDirecta;
                        for (i = 1; i <= 5; i++) {
                            if (i != origen && i != destino) {
                                tramoUno = conexiones[origen][i];
                                tramoDos = conexiones[i][destino];
                                if (tramoUno > 0 && tramoDos > 0) {
                                    distanciaCandidata = sumarDistancias(tramoUno, tramoDos);
                                    if (distanciaCandidata < distanciaTotal) {
                                        distanciaTotal = distanciaCandidata;
                                        intermedio = i;
                                    }
                                }
                            }
                        }
                        if (distanciaTotal == 9999) System.out.println("Sin ruta directa ni ruta de una parada.");
                        else {
                            System.out.println("Origen: " + nombres[origen]);
                            if (intermedio > 0) System.out.println("Pasar por: " + nombres[intermedio]);
                            System.out.println("Destino: " + nombres[destino]);
                            System.out.println("Distancia simulada: " + distanciaTotal + " unidades");
                        }
                    }
                    break;
                case 5:
                    do {
                        System.out.println("Ingrese ID del lugar de origen (1 a 5):");
                        origen = leerEntero(sc);
                    } while (origen < 1 || origen > 5);
                    System.out.println("--- DISTANCIAS DESDE " + nombres[origen] + " ---");
                    for (i = 1; i <= 5; i++) {
                        if (i != origen) {
                            distanciaDirecta = conexiones[origen][i];
                            if (distanciaDirecta > 0) System.out.println(nombres[i] + ": " + distanciaDirecta + " unidades ficticias");
                            else System.out.println(nombres[i] + ": sin conexion directa");
                        }
                    }
                    break;
                case 6:
                    System.out.println("Ingrese codigo QR (ejemplo QR-BIB):");
                    clave = sc.nextLine();
                    posicion = 0;
                    for (i = 1; i <= 5; i++) {
                        if (clave.equalsIgnoreCase(codigosQR[i])) posicion = i;
                    }
                    if (posicion > 0) {
                        System.out.println("Codigo QR reconocido.");
                        mostrarLugar(nombres[posicion], categorias[posicion], descripciones[posicion],
                                identificadores[posicion], codigosQR[posicion]);
                    } else System.out.println("Codigo QR no registrado.");
                    break;
                case 7:
                    System.out.println("Programa finalizado correctamente.");
                    break;
                default:
                    System.out.println("Opcion invalida. Elija de 1 a 7.");
            }
        }
        sc.close();
    }
    // Adaptacion de Leer: evita excepciones con texto no numerico.
    static int leerEntero(Scanner sc) {
        while (true) {
            String entrada = sc.nextLine();
            try { return Integer.parseInt(entrada.trim()); }
            catch (NumberFormatException e) {
                System.out.println("Ingrese un numero entero:");
            }
        }
    }
}
