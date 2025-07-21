defmodule Student do
  @moduledoc """
  Estructura para representar un estudiante con nombre y nota.
  """
  defstruct [:name, :grade]

  @doc """
  Crea un nuevo estudiante.

  ## Ejemplos

      iex> Student.new("Juan", 85)
      %Student{name: "Juan", grade: 85}
  """
  def new(name, grade) do
    %Student{name: name, grade: grade}
  end
end

defmodule StudentProcessor do
  @moduledoc """
  Módulo para procesar listas de estudiantes usando programación funcional.
  """

  @doc """
  Calcula el promedio de notas de una lista de estudiantes.

  ## Ejemplos

      iex> students = [%Student{name: "Ana", grade: 90}, %Student{name: "Luis", grade: 80}]
      iex> StudentProcessor.average_grade(students)
      85.0
  """
  def average_grade([]), do: 0.0

  def average_grade(students) do
    students
    |> Enum.map(& &1.grade)        # Extraer todas las notas
    |> Enum.sum()                  # Sumar todas las notas
    |> Kernel./(length(students))  # Dividir por cantidad de estudiantes
  end

  @doc """
  Filtra estudiantes que pasaron el curso (nota >= 70).

  ## Ejemplos

      iex> students = [%Student{name: "Ana", grade: 90}, %Student{name: "Luis", grade: 60}]
      iex> StudentProcessor.passed_students(students)
      [%Student{name: "Ana", grade: 90}]
  """
  def passed_students(students) do
    Enum.filter(students, & &1.grade >= 70)  # Filtrar por nota >= 70
  end

  @doc """
  Encuentra el estudiante con la nota más alta.

  ## Ejemplos

      iex> students = [%Student{name: "Ana", grade: 90}, %Student{name: "Luis", grade: 85}]
      iex> StudentProcessor.top_student(students)
      %Student{name: "Ana", grade: 90}
  """
  def top_student([]), do: nil

  def top_student(students) do
    Enum.max_by(students, & &1.grade)
  end

  @doc """
  Cuenta cuántos estudiantes pasaron y cuántos no.

  ## Ejemplos

      iex> students = [%Student{name: "Ana", grade: 90}, %Student{name: "Luis", grade: 60}]
      iex> StudentProcessor.grade_summary(students)
      %{passed: 1, failed: 1, total: 2}
  """
  def grade_summary(students) do
    passed_count = students |> passed_students() |> length()
    total_count = length(students)
    failed_count = total_count - passed_count

    %{
      passed: passed_count,
      failed: failed_count,
      total: total_count
    }
  end

  @doc """
  Transforma una lista de estudiantes en un mapa organizado por estado (aprobado/reprobado).

  ## Ejemplos

      iex> students = [%Student{name: "Ana", grade: 90}, %Student{name: "Luis", grade: 60}]
      iex> StudentProcessor.group_by_status(students)
      %{
        passed: [%Student{name: "Ana", grade: 90}],
        failed: [%Student{name: "Luis", grade: 60}]
      }
  """
  def group_by_status(students) do
    students
    |> Enum.group_by(fn student ->
      if student.grade >= 70, do: :passed, else: :failed
    end)
    |> Map.put_new(:passed, [])  # Asegurar que exista la clave :passed
    |> Map.put_new(:failed, [])  # Asegurar que exista la clave :failed
  end

  @doc """
  Aplica una bonificación a las notas de todos los estudiantes.
  Los estudiantes mantienen su identidad, pero con notas actualizadas.
  Las notas no pueden exceder 100.

  ## Ejemplos

      iex> students = [%Student{name: "Ana", grade: 90}, %Student{name: "Luis", grade: 80}]
      iex> StudentProcessor.apply_bonus(students, 5)
      [%Student{name: "Ana", grade: 95}, %Student{name: "Luis", grade: 85}]
  """
  def apply_bonus(students, bonus) do
    students
    |> Enum.map(fn student ->
      new_grade = min(student.grade + bonus, 100)  # No puede exceder 100
      %{student | grade: new_grade}
    end)
  end

  @doc """
  Genera un reporte completo de la clase.
  """
  def generate_report(students) do
    summary = grade_summary(students)
    average = average_grade(students)
    top = top_student(students)

    IO.puts("=== REPORTE DE ESTUDIANTES ===")
    IO.puts("Total de estudiantes: #{summary.total}")
    IO.puts("Aprobados: #{summary.passed}")
    IO.puts("Reprobados: #{summary.failed}")
    IO.puts("Promedio general: #{Float.round(average, 2)}")

    if top do
      IO.puts("Mejor estudiante: #{top.name} con #{top.grade} puntos")
    end

    IO.puts("\n=== ESTUDIANTES APROBADOS ===")
    students
    |> passed_students()
    |> Enum.each(fn student ->
      IO.puts("✓ #{student.name}: #{student.grade}")
    end)
  end
end

# Ejemplo de uso
defmodule StudentProcessorDemo do
  @moduledoc """
  Demostración del uso del módulo StudentProcessor.
  """

  def run_demo do
    # Crear lista de estudiantes
    students = [
      Student.new("Ana García", 92),
      Student.new("Luis Rodríguez", 78),
      Student.new("María López", 65),
      Student.new("Carlos Jiménez", 88),
      Student.new("Sofia Morales", 54),
      Student.new("Diego Vargas", 91)
    ]

    IO.puts("Ejecutando demo del procesador de estudiantes...")
    IO.puts("===============================================\n")

    # Generar reporte completo
    StudentProcessor.generate_report(students)

    # Aplicar bonificación
    IO.puts("\n=== APLICANDO BONIFICACIÓN DE 8 PUNTOS ===")
    students_with_bonus = StudentProcessor.apply_bonus(students, 8)
    StudentProcessor.generate_report(students_with_bonus)

    # Mostrar agrupación por estado
    IO.puts("\n=== AGRUPACIÓN POR ESTADO (ORIGINAL) ===")
    grouped = StudentProcessor.group_by_status(students)

    IO.puts("Aprobados:")
    Enum.each(grouped.passed, fn student ->
      IO.puts("  - #{student.name}: #{student.grade}")
    end)

    IO.puts("Reprobados:")
    Enum.each(grouped.failed, fn student ->
      IO.puts("  - #{student.name}: #{student.grade}")
    end)
  end
end

# Para ejecutar la demo, descomenta la siguiente línea:
# StudentProcessorDemo.run_demo()
