ieas = open("input.txt").readline().replace('\n','')
im = open("input.txt").read().split()[1:]

def countlightpixels(im):
    c = 0
    for s in im:
        c += s.count('#')
    return c

def tostring(im):
    return ''.join(s+'\n' for s in im)

def enhance(im,b): #im is image (less border). b is border symbol '.' or '#'
    bim = [b*(len(im[0])+4)]*2 + [b*2+s+b*2 for s in im] + [b*(len(im[0])+4)]*2
    im2 = []
    for y in range(1,len(bim)-1):
        im2 += ['']
        for x in range(1,len(bim)-1):
          s = bim[y-1][x-1:x+2] + bim[y][x-1:x+2] + bim[y+1][x-1:x+2]
          k = int(s.replace('.','0').replace('#','1'),2)
          im2[-1] += ieas[k] # look it up on the image enhancement string
    return im2

for i in range(2):
    im = enhance(im,'.') if i%2 == 0 else enhance(im,'#')

print('light pixels after 50 iters:',countlightpixels(im))
