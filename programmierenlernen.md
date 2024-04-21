# Minibeispiel, Berechnung der Gesamtoberfläche eines Quaders
Man kann Variablenzuweisungen, Input, Outout und Kontrollstrukturen sehen.


```python
#!/bin/env python3

print("Dieses Programm berechnet die Gesamtoberfläche eines Quaders.")

nochmal = "j"

while nochmal == "j":
    einheit = input("Längeneinheit der Seiten? ")

    a = int(input("Länge Seite a? "))
    b = int(input("Länge Seite b? "))
    c = int(input("Länge Seite c? "))

    O = 2 * a * b + 2 * a * c + 2 * b * c

    print("Die Gesamtoberfläche beträgt:", O, einheit + "².")

    if O > 900 :
        print("Riesending!")

    nochmal = input("Nochmal (j/n)? ")

```
