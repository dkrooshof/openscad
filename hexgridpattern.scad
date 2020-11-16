include <lib/polyround.scad>

module hexagon(hexR = 5){
    //hexR = Radius of circle in which hexagon is inscribed
    hexPoints = [for(i=[30:60:359])[hexR*cos(i),hexR*sin(i)]];    
    polygon(hexPoints);
}

module hexgridpattern(hexR = 10, spacing = 4, iter = 5, r=3, angle=0){
    //hexR = Radius of circle in which hexagon is inscribed
    //spacing = distance between sides of neighbouring hexagons
    //iter = number of hexagons in the grid in x and y directions
    //r = inscribed radius for rounding the corners of the hexagon
    //angle = angle of rotation for the entire grid pattern
    
    perpendicularEdgeLength = hexR*sin(60);
    c2c = 2*perpendicularEdgeLength + spacing;      //Centre-to-centre distance
    offsetX = -1*(hexR*sin(60)+spacing);            //Bounding rectangle offset x-dimension
    offsetY = -1*(hexR+spacing);                    //Bounding rectangle offset y-dimension
    rectX = (iter+cos(60))*c2c+spacing;             //Bounding rectangle x-dimension
    rectY = (iter-1)*sin(60)*c2c+2*(hexR+spacing);  //Bounding rectangle y-dimension
    
    round2d(0,r){
        rotate([0,0,angle]){
            translate([-rectX/2-offsetX,-rectY/2-offsetY]){ //centre around origin
                difference(){
                    //Bounding rectangle:
                    translate([offsetX,offsetY]){
                        square([rectX,rectY]);
                    }
                    //Hexagon pattern:
                    for(i=[0:iter-1],j=[0:iter-1]){
                        if(j%2==0){
                            translate([i*c2c,j*c2c*sin(60)]){
                                hexagon(hexR);
                            }
                        } else {
                            translate([i*c2c+c2c*cos(60),j*c2c*sin(60)]){
                                hexagon(hexR);
                            }
                        }
                    }   
                }
            }   
        }
    }
}

// hexgridpattern(hexR = 10, spacing = 2, iter = 15, r=3, angle=0);

module 2dShellExample(){
  radiiPoints=[[-4,0,1],[5,3,1.5],[0,7,0.1],[8,7,10],[20,20,0.8],[10,0,10]];
  //linear_extrude(1)shell2d(-0.5)polygon(polyRound(radiiPoints,30));
  linear_extrude(1)shell2d(-0.5){
    polygon(polyRound(radiiPoints,30));
    translate([8,8])hexgridpattern(hexR = 1, spacing = 0.3, iter = 17, r=0.2, angle=0);
  }
}

2dShellExample();