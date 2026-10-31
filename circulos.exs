# Universidad del Quindío - Programación III
# Generador Recursivo de Círculos Concéntricos (Configuración + Interactivo)

defmodule CirculosConcentricos do
  def main do
    IO.puts("==================================================")
    IO.puts("   GENERADOR RECURSIVO DE CÍRCULOS CONCÉNTRICOS   ")
    IO.puts("==================================================")

    nombre_archivo = "circulos.txt"

    case File.read(nombre_archivo) do
      {:ok, contenido} ->
        # 1. Leemos los parámetros base del archivo de texto
        # (Ignoramos el 4to valor del txt porque lo pediremos por consola)
        [cx, cy, radio_inicial, _cantidad_txt, reduccion] =
          contenido
          |> String.split([",", "\n"], trim: true)
          |> Enum.map(&String.trim/1)
          |> Enum.map(&String.to_integer/1)

        # 2. Le pedimos al usuario la cantidad por teclado
        IO.write("👉 Ingrese el número de círculos a dibujar (ej: 15): ")

        cantidad =
          IO.gets("")
          |> String.trim()
          |> String.to_integer()

        IO.puts("\n Generando #{cantidad} círculos con centro en (#{cx}, #{cy})...\n")

        # 3. GENERACIÓN RECURSIVA
        elementos_svg = generar_circulos_cola(cx, cy, radio_inicial, cantidad, reduccion, [])

        # 4. ENSAMBLADO SVG
        ancho = cx * 2
        alto = cy * 2

        contenido_svg = """
        <svg xmlns="[suspicious link removed]" width="#{ancho}" height="#{alto}" viewBox="0 0 #{ancho} #{alto}">
          <!-- Fondo oscuro -->
          <rect width="100%" height="100%" fill="#1a1a2e" />

          <!-- Círculos concéntricos -->
        #{elementos_svg}
        </svg>
        """

        # 5. GUARDAR ARCHIVO
        File.write!("circulos.svg", contenido_svg)
        IO.puts("✅ Archivo 'circulos.svg' generado exitosamente con #{cantidad} círculos.")

      {:error, razon} ->
        IO.puts("❌ Error al leer el archivo '#{nombre_archivo}': #{inspect(razon)}")
    end
  end

  # ===================================================================
  # RECURSIVIDAD DE COLA CON ACUMULADOR
  # ===================================================================

  defp generar_circulos_cola(_cx, _cy, _radio, 0, _reduccion, acum) do
    Enum.join(Enum.reverse(acum), "\n")
  end

  defp generar_circulos_cola(_cx, _cy, radio, _cantidad, _reduccion, acum) when radio <= 0 do
    Enum.join(Enum.reverse(acum), "\n")
  end

  defp generar_circulos_cola(cx, cy, radio, cantidad_restante, reduccion, acum) do
    color = obtener_color(cantidad_restante)

    circulo_tag =
      "  <circle cx=\"#{cx}\" cy=\"#{cy}\" r=\"#{radio}\" fill=\"none\" stroke=\"#{color}\" stroke-width=\"3\" />"

    generar_circulos_cola(cx, cy, radio - reduccion, cantidad_restante - 1, reduccion, [
      circulo_tag | acum
    ])
  end

  defp obtener_color(i) do
    colores = [
      "#00fff5",
      "#00d2ff",
      "#3a7bd5",
      "#4a00e0",
      "#8e2de2",
      "#f000ff",
      "#ff007f",
      "#ff5e62",
      "#ff9966",
      "#f8ff00"
    ]

    Enum.at(colores, rem(i, length(colores)))
  end
end

CirculosConcentricos.main()
