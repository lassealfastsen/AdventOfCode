points = []
with open(r'C:\git\AdventOfCode\2025\Day 9\input.txt') as f:
    line = f.readline()
    while line:
        points.append(tuple([int(n) for n in line.split(',')]))
        line = f.readline()
num_points = len(points)
        
def area(c1, c2):
    x1, y1 = c1
    x2, y2 = c2
    return (abs(x1-x2)+1)*(abs(y1-y2)+1)
    

horizontal_edges = []
vertical_edges = []
pointcloud = []
for i in range(num_points):
    while len(pointcloud) <= points[i][1]:
        pointcloud.append([])
    pointcloud[points[i][1]].append(points[i][0])
    j = (i+1)%num_points

    
    if points[i][0] == points[j][0]:
        while len(vertical_edges) <= points[i][0]:
            vertical_edges.append([])
        vertical_edges[points[i][0]].append((min(points[i][1], points[j][1]), max(points[i][1], points[j][1])))
    else:
        while len(horizontal_edges) <= points[i][1]:
            horizontal_edges.append([])
        horizontal_edges[points[i][1]].append((min(points[i][0], points[j][0]), max(points[i][0], points[j][0])))
        
for i in range(len(vertical_edges)):
    vertical_edges[i].sort()

for i in range(len(horizontal_edges)):
    horizontal_edges[i].sort()
    
squares = []
for i, c1 in enumerate(points):
    for c2 in points[i+1:]:
        squares.append((c1, c2, area(c1,c2)))

squares.sort(key=lambda n : n[2], reverse=True)

    
candidates = []
for c1, c2, d in squares:
    x1, y1 = c1
    x2, y2 = c2
    top = min(y1,y2)
    bottom = max(y1,y2)
    left = min(x1, x2)
    right = max(x1, x2)
    #let's first try to get any squares without any inner points
    failed = False
    for y in range(top+1, bottom):
        for x in pointcloud[y]:
            if x > left and x < right:
                failed = True
                break
        for l,r in horizontal_edges[y]:
            if left > l and left < r:
                failed = True
                break
        if failed:
            break
    if failed:
        continue

    candidates.append(d)
    print(c1, c2, d)
    break
    
print(candidates)
    