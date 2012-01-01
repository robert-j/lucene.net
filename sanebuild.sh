#!/bin/bash
#
# Simple & Sane(TM) build script for Lucene.Net.
#

MSBUILD=MSBuild.exe
MSBUILD_TARGETS="Debug Release"
SOURCE_DIR="build/vs2010"
OUTPUT_DIR="build/bin"
OUTPUT_EXTENSIONS="dll pdb XML"

SOLUTIONS="core/Lucene.Net.Core \
    contrib/Contrib.Analyzers \
    contrib/Contrib.SpellChecker \
    contrib/Contrib.Queries \
    contrib/Contrib.Snowball \
    contrib/Contrib.Highlighter \
    contrib/Contrib.FastVectorHighlighter"

#
# build targets
#
for solution in $SOLUTIONS
do
    for target in $MSBUILD_TARGETS
    do
	$MSBUILD /p:Configuration=$target $SOURCE_DIR/$solution.sln
    done
done

#
# copy targets into bin/{Debug|Release}
#
for target in $MSBUILD_TARGETS
do
    mkdir -p bin/$target

    for ext in $OUTPUT_EXTENSIONS
    do
	# copy contrib files
	find $OUTPUT_DIR/*/*/$target -name "*.$ext" -print0 | \
	    xargs -0 -I {} cp -a {} bin/$target

	# copy core files
	find $OUTPUT_DIR/*/$target -name "*.$ext" -print0 | \
	    xargs -0 -I {} cp -a {} bin/$target
    done
done
