# worm_simulation_matlab
A MATLAB implementation of a computer worm as it spreads through a network of routers.
The worm can spread from cellphone-to-router and router-to-router.

World Space:
```

            n = 2

+------+------+------+------+
|      |      |      |      |
|  C   |      |      |      |
|      |      |      |      |
+------R-------------R------+
|      |      |      |      |
|      |      |      |      |
|      |      |      |      |
+---------------------------+  m = 2
|      |      |      |      |
|      |      |  C   |      |
|      |      |      |      |
+------R-------------R------+
|      |      |      |      |
|      |      |      |      |
|      |      |      |      |
+------+------+------+------+

R : location of a router
C : location of a cellphone
n : number of 2x2 blocks, width-wise
m : number of 2x2 blocks, height-wise
```
