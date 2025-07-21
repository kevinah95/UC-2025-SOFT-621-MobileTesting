-- Definir el tipo de dato Student (nombre y nota)
data Student = Student String Int deriving (Show)

-- Función para extraer la nota de un estudiante
studentGrade :: Student -> Int
studentGrade (Student _ grade) = grade

-- Función para extraer el nombre de un estudiante
studentName :: Student -> String
studentName (Student name _) = name

-- Calcular promedio de notas
averageGrade :: [Student] -> Double
averageGrade students =
    fromIntegral (sum grades) / fromIntegral (length grades)
    where grades = map studentGrade students

-- Filtrar estudiantes que pasaron (nota >= 70)
passedStudents :: [Student] -> [Student]
passedStudents = filter (\s -> studentGrade s >= 70)

main :: IO ()
main = do
    -- Crear lista de estudiantes
    let students = [
            Student "Ana" 85,
            Student "Bob" 65,
            Student "Carlos" 92,
            Student "Diana" 78,
            Student "Eva" 55
            ]

    -- Mostrar todos los estudiantes
    putStrLn "=== Todos los estudiantes ==="
    mapM_ print students

    -- Calcular y mostrar promedio
    putStrLn "\n=== Promedio de notas ==="
    print (averageGrade students)

    -- Mostrar estudiantes aprobados
    putStrLn "\n=== Estudiantes aprobados (nota >= 70) ==="
    mapM_ print (passedStudents students)

    -- Mostrar solo las notas de los aprobados
    putStrLn "\n=== Notas de los aprobados ==="
    print (map studentGrade (passedStudents students))
