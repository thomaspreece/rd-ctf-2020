import zipfile
import os

first_zip = zipfile.ZipFile('flag.zip', 'w')
first_zip.write('flag.txt', compress_type=zipfile.ZIP_DEFLATED)
first_zip.close()

for i in range(500):
    recurse_zip = zipfile.ZipFile('newflag.zip', 'w')
    recurse_zip.write('flag.zip', compress_type=zipfile.ZIP_DEFLATED)
    recurse_zip.close()
    os.remove("flag.zip")
    os.rename("newflag.zip", "flag.zip")
