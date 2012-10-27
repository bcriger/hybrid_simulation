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

use <Thread_Library.scad>

bodyid=40.25;
bodyod=41.5;
noseconeheight=100;
wallt=1.25;
bottomt=2;
pitch=5;
holed=3;
reinforced=3;
threadd=32;
noser=5;

ogivenosecone();
//base();
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
function nosex0(r,l,rho,rn) = l-sqrt(pow(rho-rn,2)-pow(rho-r,2));
function noseyt(rn,rho,r) = rn*(rho-r)/(rho-rn);
function nosext(x0,rn,yt) = x0-sqrt(rn*rn-yt*yt);

module ogive(d=bodyod,l=noseconeheight,fnl=180,fnr=24,rn=noser){
	r = d/2;
	rho = ogiverho(r,l);
	x0 = nosex0(r,l,rho,rn);
	yt = noseyt(rn,rho,r);
	xt = nosext(x0,rn,yt);
	union(){
		rotate_extrude($fn=fnr){
			intersection(){
				translate([r-rho,0]) circle(r=rho,$fn=fnl);
				square([r,l-xt]);
			}
		}
		translate([0,0,l-x0]) sphere(r=rn,$fn=fnr);
	}
}

module ogivenosecone(diameter=bodyod,height=noseconeheight,wallt=wallt){
	factor=(diameter-2*wallt)/diameter;
	difference(){
		ogive(diameter,height);
		baseneg();
		difference(){
			ogive(factor*diameter,factor*height);
			cylinder(r=bodyod/2,h=bodyid/2);
		}
	}
}

module base(bodyid=bodyid,baseh=bodyid/2,threadh=bodyid/2,pitch=pitch,wallt=wallt,holed=holed,threadd=threadd,bottomt=bottomt){
	difference(){
		union(){
			translate([0,0,baseh-0.01]) trapezoidThread(length=threadh,pitchRadius=threadd/2-pitch/4,pitch=pitch);
			cylinder(r=bodyid/2,h=baseh);
		}
		translate([0,0,bottomt]) cylinder(r=threadd/2-wallt-pitch/2,h=bodyid);
		translate([(reinforced+holed)/2,0,-1]) cylinder(r=holed/2,h=bottomt+2,$fn=12);
		translate([-(reinforced+holed)/2,0,-1]) cylinder(r=holed/2,h=bottomt+2,$fn=12);
	}
	translate([0,0,bottomt])
	rotate([90,0,0])
		difference(){
			cylinder(r=reinforced/2,h=bodyid-2*wallt,center=true,$fn=12);
			translate([0,-reinforced/2,0]) cube([reinforced,reinforced,bodyid],center=true);
		}
}

module baseneg(bodyid=bodyid,baseh=bodyid/2,threadh=bodyid/2,pitch=pitch,wallt=wallt,holed=holed,threadd=threadd){
	trapezoidThreadNegativeSpace(length=threadh,pitchRadius=threadd/2-pitch/4,pitch=pitch,countersunk=0.05);
}
