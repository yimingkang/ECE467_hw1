import re
import sys

KNOWN_TOKENS = [
        'if', 'else', 'for', 'while', 'void', ',', '(', ')', 
        '{', '}', '[', ']', ':', 'bool', 'int', 'float',
        '"', 'dp3', 'lit', 'rsq', '=', 'const', ';', '\'',
]

def main(file_name):
    lex_output_regex = re.compile(r"TOKEN\s+(\d{3})\s+:\s+(.*)")
    seen_tokens = dict()
    ret = 0
    with open(file_name, 'r') as fin:
        for line in fin:
            matched = lex_output_regex.match(line)
            value = matched.group(1)
            token = matched.group(2)
            if token in KNOWN_TOKENS:
                if token in seen_tokens.keys():
                    if seen_tokens[token] != value:
                        print "ERROR: Token ", token, " is asigned a new value!"
                        ret = -1
                else:
                    seen_tokens[token] = value
    # print seen_tokens
    return ret

if __name__ == '__main__':
    if len(sys.argv) != 2:
        print "ERROR: Invalid argument"
        exit(0)
    print "***** TEST START*****"
    if main(sys.argv[1]) == -1:
        print "***** TEST FAILED *****"
    else:
        print "***** TEST PASSED *****"

