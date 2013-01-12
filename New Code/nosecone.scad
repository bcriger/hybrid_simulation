// Tangent ogive nose cone with spherical tip
// Threaded detachable base for printability and use as a small payload bay
// By bld: http://www.thingiverse.com/bld
// Modifications by bcriger: http://www.thingiverse.com/bcriger
// License: Creative Commons Attribution Share-Alike 3.0: http://creativecommons.org/licenses/by-sa/3.0/
//
// Equations from: http://en.wikipedia.org/wiki/Nose_cone_design#Tangent_ogive
// Thread library by syvwlch: http://www.thingiverse.com/thing:8793
//
// Parameters
// ==========
// bodyid: body tube inner diameter
// bodyod: body tube outer diameter
// noseconeheight
// wallt: wall thickness
// bottomt: thickness of base bottom
// pitch: thread pitch
// holed: diameter of holes in base for attaching shock cord
// reinforced: diameter of reinforcement for shock cord
// threadd: outer diameter of threads
// noser: radius of curvature of spherical nose
//
// Modules
// =======
// ogivenosecone: threaded ogive nosecone
// base: threaded base that screws onto nosecone
// fitcheck: fast printing test piece to check fit into body tube

/////////////////////////////////////
bodyid=3.75*2.54;
bodyod=4*2.54;
noseconeheight=6.5*2.54;
wallt=0.125*2.54;
bottomt=0.125*2.54;
pitch=5;
holed=3;
reinforced=3;
threadd=32;
noser=0;
threaded=0;
curvepoints=30;
/////////////////////////////////////

pi=3.1415926535897932384626;

//ogivenosecone();
//VKplug();
//base();
//VKshell();
VKcone();
//fitcheck();

// Fit check: quick print to test fit in body tube
module fitcheck(){
	difference(){
		union(){
			cylinder(r=bodyod/2,h=wallt);
			cylinder(r=bodyid/2,h=bodyid/4);
		}
		translate([0,0,-1]) cylinder(r=bodyid/2-wallt,h=bodyid/2+2);
	}
}

function ogiverho(r,l) = (r*r+l*l)/(2*r);
function ogivey(rho,x,r,l) = sqrt(rho*rho-pow(l-x,2))+r-rho;
function ogivenosex0(r,l,rho,rn) = l-sqrt(pow(rho-rn,2)-pow(rho-r,2));
function ogivenoseyt(rn,rho,r) = rn*(rho-r)/(rho-rn);
function ogivenosext(x0,rn,yt) = x0-sqrt(rn*rn-yt*yt);

function VKt(x,L) = acos(1-2*x/L)/180*pi;
function VKy(x,R,L) = R/sqrt(pi)*sqrt(VKt(x,L)-sin(2*VKt(x,L)*180/pi)/2);

module VKplug(rad=bodyod/2,len=noseconeheight,points=30){
	union(){
		for(ex=[0:len/points:len-len/points]){
			translate([0,0,-ex-len/points]) cylinder(h=len/points,r1=VKy(ex+len/points,rad,len),r2=VKy(ex,rad,len), $fn=50);
		}
	}
}

module VKshell(rad=bodyod/2,thickness=2*wallt,length=noseconeheight,points=curvepoints){
	difference(){
		VKplug(rad=rad,len=length,points=curvepoints);
		translate([0,0,-thickness-rad/4]) VKplug(rad=rad-thickness,len=length-thickness,points=curvepoints);
}	
}

module base(thickness=wallt, od=bodyid){
	difference(){
			cylinder(h=od,r=od/2,$fn=30);
			translate([0,0,-od/10])cylinder(h=12*od/10,r=9*od/20,$fn=20);
			}
}

module VKcone(){
	union(){
		VKshell();
		translate([0,0,-9*bodyod/10-noseconeheight])base();
	}
}