
$pth = '.\2021\day 10\input.txt'
$reader = New-Object System.IO.StreamReader($pth)

$read = "{([(<{}[<>[]}>{[]{[(<()>"


$score = 0
while ($read = $reader.ReadLine()) {
    $stack = ""
    :loop foreach ($char  in $read.ToCharArray()) {
        if ($char -in @('(', '[', '{', '<')) {$stack = "$($stack)$char"}
        else {
            if ($char -eq ')') {
                if ($stack.Substring($stack.Length-1) -ne '(')  {
                    "Invalid )"
                    $score += 3
                    break :loop
                } else {
                    $stack = $stack.Substring(0, $stack.Length-1)
                }
            }
            elseif ($char -eq ']') {
                if ($stack.Substring($stack.Length-1) -ne '[')  {
                    "Invalid ]"
                    $score += 57
                    break :loop
                } else {
                    $stack = $stack.Substring(0, $stack.Length-1)
                }
            }
            elseif ($char -eq '}') {
                if ($stack.Substring($stack.Length-1) -ne '{')  {
                    "Invalid }"
                    $score += 1197
                    break :loop
                } else {
                    $stack = $stack.Substring(0, $stack.Length-1)
                }
            }
            elseif ($char -eq '>') {
                if ($stack.Substring($stack.Length-1) -ne '<')  {
                    "Invalid >"
                    $score += 25137
                    break :loop
                } else {
                    $stack = $stack.Substring(0, $stack.Length-1)
                }
            }
        }
    }
}

$reader.Close()
$reader.Dispose()

$score
