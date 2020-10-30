import zipfile
import os

flag = "CTF{assemble_the_pieces}"

first_zip = zipfile.ZipFile('flag.zip', 'w')
first_zip.write('flag.txt', compress_type=zipfile.ZIP_DEFLATED)
first_zip.close()

for i in range(500):
    recurse_zip = zipfile.ZipFile('newflag.zip', 'w')
    recurse_zip.write('flag.zip', compress_type=zipfile.ZIP_DEFLATED)
    recurse_zip.close()
    os.remove("flag.zip")
    os.rename("newflag.zip", "flag.zip")

for i in range(len(flag)):
    recurse_zip = zipfile.ZipFile('newflag.zip', 'w')
    recurse_zip.write('flag.zip', compress_type=zipfile.ZIP_DEFLATED)
    recurse_zip.writestr("flag.txt", flag[i])
    print(flag[i])
    recurse_zip.close()
    os.remove("flag.zip")
    os.rename("newflag.zip", "flag.zip")

for i in range(20):
    recurse_zip = zipfile.ZipFile('newflag.zip', 'w')
    recurse_zip.write('flag.zip', compress_type=zipfile.ZIP_DEFLATED)
    recurse_zip.close()
    os.remove("flag.zip")
    os.rename("newflag.zip", "flag.zip")
