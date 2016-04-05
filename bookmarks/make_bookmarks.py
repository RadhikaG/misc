# Make sure you used the html2text utility provided with this file only
# Change has been made on line 46 in html2text.py to prevent wrapping
import html2text # Long live Aaron Swartz.
import sys
import re

def make_contents(md):
    contents = ['## Contents:\n']
    md = md.split('\n')
    for line in md:
        if '##' in line and '###' not in line:
            line = line.replace('#', '')
            line = line.strip()
            lineSan = line.lower().replace('/', '').replace('.', '').replace(' ', '-')
            line = '* '+'['+line+']'+'(#'+lineSan+')'
            contents.append(line+'\n')

    for i in range(len(md)):
        md[i] = md[i] + '\n'
        contents.append(md[i])

    # print(contents)
    md = ''.join(contents)

    return md


def process_md(md):
    md = md.split('\n')
    # print(md)

    # To understand what fixStartHeading and fixEndHeading do,
    # read the comments further below. If you don't get it,
    # just let the below 2 lines be as they are, they won't complain.
    fixStartHeading = 'Paradigm/Language Specific'
    fixEndHeading = 'Literary'
    # finishHeading is the subheading where you'd like the public
    # list to be finished. Let it be as it is if you're unsure.
    finishHeading = 'General List'
    # Change the above 3 headings swaad-anusaar. If you keep them as
    # they are, you'll have to manually edit your output file a bit
    # to snip out folders and subheadings you don't want.

    fixStartInd = 0
    fixEndInd = 0
    finishInd = len(md) - 1

    for i in range(len(md)):
        if fixStartHeading in md[i]:
            fixStartInd = i
        elif fixEndHeading in md[i]:
            fixEndInd = i
        elif finishHeading in md[i]:
            finishInd = i

    for j in range(len(md)):

        # I didn't want the ### headings the html2text utility
        # was giving me everywhere, except between fixStartHeading 
        # and fixEndHeading.
        # If you'd like to keep the ### headings as given by html2text,
        # just comment the 3 lines below.
        if '###' in md[j]:
            if not fixStartInd < j < fixEndInd:
                md[j] = md[j].replace('###', '##')

        # The following lines may end up screwing up your markdown formatting,
        # depending on the special symbols your links/link text may contain.
        # Please be prepared to manually edit your output file a bit to fix these,
        # although changes should (hopefully) be minimal.
        # TODO: make sure find/replace operations don't screw up links/link text

        # sanitizing brackets and separating each link into a separated line
        md[j] = md[j].replace(' [', '[').replace(')[', ')\n[')
        # This line below causes problems when the link text has a '[' in it.
        # If/when it renders all the text following it in italics,
        # just remove it manually.
        # This is a known bug and will be fixed in the future
        # Correctly prepending the link with bullet point
        md[j] = md[j].replace('[', '* [')
        # adding the \n after previously having split it by \n
        md[j] = md[j] + '\n'

    # This '8' is to ignore the first 8 elements of md
    # This is very specific to the directory structure of your bookmarks
    # The elements are ignored on the basis of which heading do you want your
    # public list to start from.
    # If confused, just replace the '8' with a 0, and modify the output file manually.
    md = md[8:finishInd]

    md = ''.join(md)
    # print(md)
    return md


# Command line argument is an exported bookmarks HTML file
f = open(sys.argv[1])

md = html2text.html2text(f.read())
# print(md) # uncomment this line to check md before it is sanitized
md = process_md(md)
md = make_contents(md)
# print(md)
f1 = open("bookmarks.md", "w") # change 'bookmarks.md' to a different output file if you like
f1.write(md)
f1.close()
f.close()
