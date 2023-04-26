# Verschiedene Tools und ihre Aufrufe um Bilder zu konvertieren

## Erzeugen von PDFs aus Grafikdatein (vorzugsweise png)

dafür wird img2pdf benutzt. (Installation mit ```sudo port install img2pdf```)
```bash
img2pdf --output Dokument.pdf -S A4^T Seite1.png Seite2.png 
```
- Dokument.pdf ist die Ausgabedatei
- ```-S A4^T``` legt das Zielformat fest und ^T sorgt für Querformat
- Seite1.png und Seite2.png sind die Grafiken die im PDF landen sollen. hier kann man soviel auflisten wie man will
