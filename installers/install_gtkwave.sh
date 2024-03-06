#!/bin/bash

set -ex
set -u

sudo pacman -S meson || true
apt install -y --no-install-recommends meson || true

git clone --filter=blob:none https://github.com/gtkwave/gtkwave gtkwave || true
cd gtkwave
#git checkout 51aa052db9440d634f588178759f20fec4cffdc2

# FIXME Remove the parameter that declares a missing include directory as an error 
# because the build fails otherwise (hopefully PR will be merged at some time).

patch -p1 << EOF
diff --git a/meson.build b/meson.build
index c99f728..931d461 100644
--- a/meson.build
+++ b/meson.build
@@ -160,7 +160,6 @@ test_warning_args = [
     '-Werror=main',
     '-Werror=misleading-indentation',
     '-Werror=missing-braces',
-    '-Werror=missing-include-dirs',
     '-Werror=nonnull',
     '-Werror=overflow',
     '-Werror=parenthesis',
EOF

meson setup build
meson compile -C build
meson install -C build
