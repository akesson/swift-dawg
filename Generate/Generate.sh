#!/bin/sh

#  Generate.sh
#
#  Created by Henrik Akesson on 27/08/2018.
#  Copyright © 2018 Henrik Akesson. All rights reserved.

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

cd $SCRIPT_DIR

if [ -e fbsCG ]; then
    echo "FlatBuffersSwiftCodeGen already downloaded"
else
    echo "Downloading FlatBuffersSwiftCodeGen"
    wget https://github.com/mzaks/FlatBuffersSwiftCodeGen/raw/master/fbsCG
    chmod u+x ./fbsCG
fi


for fbsFile in *.fbs; do
    swiftFile="${fbsFile/.fbs/.swift}"
    echo "Converting $fbsFile to $swiftFile"
	./fbsCG $fbsFile ../Sources/Generated/$swiftFile
done

