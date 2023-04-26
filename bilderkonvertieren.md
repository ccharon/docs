# Verschiedene Tools und ihre Aufrufe um Bilder zu konvertieren

## Erzeugen von PDFs aus Grafikdateien (vorzugsweise png)

dafür wird img2pdf benutzt. (Installation mit ```sudo port install img2pdf```)
```bash
img2pdf --output Dokument.pdf -S A4^T Seite1.png Seite2.png 
```
- Dokument.pdf ist die Ausgabedatei
- ```-S A4^T``` legt das Zielformat fest und ^T sorgt für Querformat
- Seite1.png und Seite2.png sind die Grafiken die im PDF landen sollen. hier kann man soviel auflisten wie man will

## Kompression von Bildern für eine Webseite um kleinere Versionen oder Vorschaubilder zu erstellen

dafür wird imagemagick (mogrify) benutzt (Installation mit ```sudo port install imagemagick```)
```bash
mogrify -path ./Thumbnails/ -filter Triangle -define filter:support=2 -thumbnail 300 -unsharp 0.25x0.08+8.3+0.045 -dither None -posterize 136 -quality 82 -define jpeg:fancy-upsampling=off -define png:compression-filter=5 -define png:compression-level=9 -define png:compression-strategy=1 -define png:exclude-chunk=all -interlace none -colorspace sRGB ./Original/Bild.png
```
