# tests with playwright

$ npm init playwright@latest
$ sudo npx playwright install-deps
$ python -m venv venv
$ source venv/bin/activate
$ pip install pytest-playwright
$ pytest --browser webkit --headed tests/test.py

interrompu car les deps systemes sont pas à jour pour debian 12
E       ╔══════════════════════════════════════════════════════╗
E       ║ Host system is missing dependencies to run browsers. ║
E       ║ Missing libraries:                                   ║
E       ║     libicui18n.so.66                                 ║
E       ║     libicuuc.so.66                                   ║
E       ║     libjpeg.so.8                                     ║
E       ║     libwebp.so.6                                     ║
E       ║     libffi.so.7                                      ║
E       ╚══════════════════════════════════════════════════════╝

