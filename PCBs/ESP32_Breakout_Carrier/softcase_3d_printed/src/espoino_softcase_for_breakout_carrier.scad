//////////////////////////////////////////////////////////////////////////////////////
///  ESPuino case with soft padding
///
///  This files generates the 3d printed parts for an ESPuino containing
///  the breakout carrier PCB and a Visaton FRS 5
///
///  The preconfigured battery holders utilices 2x 18650.
///
///  Componenent list:
///   - 3x Arcade Buttons Switch 24 x 33 mm
///   - Visaton FRS 5
///   - ESPuino breakout carrier board
///   - AZDelivery RFID RC522 board
///   - 5.5mm x 2.1mm buchse
///   - 5.5mm x 2.1mm stecker
///   - usb cable
///   - micro usb breakout board
///   - tp4056 board
///   - 2x 18650 cells
///   - 2x protection board pcb for 18650 cell
//////////////////////////////////////////////////////////////////////////////////////
///
///  2021-05-12 Philipp Schönberger Bodensee, Deutschland
///
///  released under Creative Commons
///    Attribution-NonCommercial-ShareAlike 4.0 International
///    (CC BY-NC-SA 4.0)
//////////////////////////////////////////////////////////////////////////////////////

$e=0.01;
$fn=64;
clear=0.2;
fabric=1.0;
wall=3;

button_d=23.5+clear*3;
button_h=20;
button_distance=30;
button_offset=-43.5;
button_cut_w=28.5;
button_cut_d=7;

x=5;
led_ring_offset=13+x;
rfid_offset=12+x;

fab_extra=0;
box_size=[145-fab_extra,145-fab_extra,120];
softshell=10;

font="Arial Rounded MT Bold:style=Bold";
font_size=3.75;
font_size_name=5.5;
font_spaceing=1.25;
led_extra_h=0;

show_top_infill=1;
show_top_plate=1;
show_inner_box=1;
show_outer_clampring=1;
show_outer_box=1;
show_charge_port_holder=1;
show_charge_port_outer_part=1;
show_charging_station=1;

show_buttons=1;
show_speaker=1;
show_pcb_rfid=1;
show_pcb_main=1;
show_plug=1;
show_port=1;

use<uploads_68_57_32_89_55_flexbatter.scad>;

function gif_offset_pos(t) = [-box_size[0]/2,-box_size[1]/2,-box_size[2]/2]; 
function gif_offset_rot(t) = [0,0,t*360]; 

box_outer_size=[box_size[0]-softshell*2,
                box_size[1]-softshell*2,
                box_size[2]-softshell*2];
box_inner_size=[box_outer_size[0]-wall*2-clear*2-fabric*2,
                box_outer_size[1]-wall*2-clear*2-fabric*2,
                box_outer_size[2]-wall*2-clear*2];

pcb_main_size=[72.5,83,1.6];
distance_behind_pcb=3;

//                        plastic part
h_charge_plug=[9,   2,    10,    9   ];
w_charge_plug=[5.5, 2.2,  10.5,  15,   ];

outer_charg_port_screw_d=3+clear*2;
h_charge_port=[21.4, 16.5, 11.5, 2   ];
w_charge_port=[2.4,  9.4,  10.5, 12.55,];

speaker_front_diameter=50;
speaker_screw_dist=60;

screw_d=3;
screw_d_head=6;
screw_h_head=2;

charger_plug_hole=20;
charg_port_screw_d_head=6+2*clear;
charg_port_screw_d=3+2*clear;
charg_port_screw_h=2+clear;
//////////////////////////////////////////////////////////
// module section

module part_model_infill() {

    logo_groove=0.3*2;
    h=logo_groove+$e;
    translate([box_size[0]/2,box_size[1]/2,box_size[2]-softshell+1+$e]) {
        translate([0,led_ring_offset,2-logo_groove]) {

            // ring 0
            cylinder(d=10,h=h);

            // cut for ring 2/3
            for( r = [30,50])
            intersection()
            {
                for ( x = [0,180] )
                hull() {
                    for ( i = [45,-45] )
                    rotate([0,0,i+x])
                    translate([0,-$e,-$e])
                    cube([r+10,$e*2,h+$e*2]);
                }


                // ring 2
                difference() {
                    cylinder(d=r+10,h=h);
                    translate([0,0,-$e])
                    cylinder(d=r,h=h+$e*2);
                }
            }

        }
    }
}

module subpart_pcb_holder() {
    end_clear=0;
    pcb_clamp=3;
    clear=0.3;
    difference() {
        union() {
            translate([0,0,0])
            cube([
                  wall+pcb_clamp,
                    pcb_main_size[1] - end_clear,
                  distance_behind_pcb+wall+pcb_main_size[2]
                 ]);
            translate([clear*2+wall+pcb_main_size[0]-pcb_clamp,end_clear,0])
            cube([
                  wall+pcb_clamp,
                  pcb_main_size[1] - end_clear,
                  distance_behind_pcb+wall+pcb_main_size[2]
                 ]);
        }

        translate([wall+clear,-$e,distance_behind_pcb])
        cube([pcb_main_size[0]+2*clear,pcb_main_size[1]+$e*2,pcb_main_size[2]+2*clear]);


        translate([pcb_main_size[0]-4,4,-$e])
        cylinder(d=3,h=pcb_main_size[2]+$e*2);
    }
}

module part_outer_plate() {
    r=4;
    step=3;
    h=5;

    difference() {
        color("lightblue")
        translate([softshell/2,softshell/2,0])
        translate([r,r,box_size[2]-softshell-wall]) {
            hull() {
                minkowski() {
                cube([box_size[0]-softshell-r*2,
                      box_size[0]-softshell-r*2,
                      $e]);
                    cylinder(r=r,h=3-$e);
                }
                translate([step,step,h-$e])
                minkowski() {
                cube([box_size[0]-softshell-r*2-step*2,
                      box_size[0]-softshell-r*2-step*2,
                      $e]);
                    cylinder(r=r,h=$e);
                }
            }
        }
        // buttons cuts
        {
            for ( x = [-1,0,1] )
                translate([box_size[0]/2+x*button_distance,
                           box_size[1]/2+button_offset,
                           box_size[2]-softshell-wall]) {
                    cylinder(d=button_d,h=h+$e*2);
                    translate([-button_cut_w/2,-button_cut_d/2,-1])
                    cube([button_cut_w,button_cut_d,h+$e*2]);
                }

        }

        // rfid cut
        {
            translate([box_size[0]/2,box_size[1]/2+rfid_offset,-$e])
            translate([-20,30.5,0])
            rotate([0,0,-90]) {
                translate([0,0,box_size[2]-softshell-wall])
                translate([0,0,0])
                cube([60+2*clear,39.5+clear*2,6.3-wall-1+$e]);
            }
        }
        // rfid logo
        {
            part_model_infill();
        }

        // led cutout
        {
            translate([box_size[0]/2,box_size[1]/2,box_size[2]-softshell]) {
                h_led=3;
                // led
                %translate([0,led_ring_offset,3-h_led-1.5])
                color("black")
                difference() {
                    cylinder(d=91+clear,h=h_led);
                    translate([0,0,-$e])
                    cylinder(d=74,h=h_led+$e*2);
                }

                translate([0,led_ring_offset,3-(h_led+10)-1.5])
                difference() {
                    cylinder(d=91+clear,h=h_led+10+led_extra_h);
                    translate([0,0,-$e])
                    cylinder(d=74,h=h_led+10+$e*2+led_extra_h);
                }
            }
        }

        // screw holes

        for(i=[0:90:359])
        {
            translate([box_size[0]/2,box_size[1]/2,box_size[2]-softshell/2-h-2.75-$e])
            rotate([0,0,i])
            translate([box_inner_size[0]/2 - 8,box_inner_size[1]/2 - 8,0]) {
                //cylinder($fn=6,d=6.01+clear*2,h=3);
                cylinder(d=3+clear*2,h=10);
                translate([0,0,5.8-1.5])
                cylinder(d=6,h=3);
            }
        }
    }
}

module part_inner_box() {
    color("orange")
    translate([wall+clear+softshell+fabric,wall+clear+softshell+fabric,wall+clear+softshell])
    {
        difference() {
            union(){
                cube([box_inner_size[0],
                      box_inner_size[1],
                      box_inner_size[2]+wall,
                ]);
            }


            // inner cutout
            translate([wall,wall,-$e]) {
                cube([box_inner_size[0]-wall*2,
                      box_inner_size[1]-wall*2,
                      box_inner_size[2]+$e,
                ]);
            }

            // speaker screw holes
            for ( i = [-1,1] )
            translate([box_inner_size[0]/2,wall+$e,box_inner_size[2]/2])
            translate([speaker_screw_dist*0.5*i,2*wall,0])
            rotate([90,0,0]){
                cylinder(d=screw_d,h=wall*4);
                translate([0,0,wall*2+fabric+$e*2])
                    cylinder(d2=screw_d_head,d1=screw_d,h=screw_h_head);
            }


            // speaker holes
            {
                translate([box_inner_size[0]/2,wall+$e,box_inner_size[2]/2]) {
                    rotate([90,0,0]) {
                    cylinder(d=speaker_front_diameter,h=wall+$e*2);
                    }

                }
            }
            // rfid /led cable cuts
            {
                r=9;
                cable_w=50-r;
                hull()
                for ( x = [-1,1] ) {
                    translate([box_inner_size[0]/2+x*cable_w,box_inner_size[1]/2+rfid_offset-20,box_inner_size[2]+wall*2-button_h-$e])
                        cylinder(d=r,h=button_h);
                    translate([box_inner_size[0]/2+x*cable_w,box_inner_size[1]/2+rfid_offset-30,box_inner_size[2]+wall*2-button_h-$e])
                        cylinder(d=r,h=button_h);
                }
                // magnet cutout
                translate([box_inner_size[0]/2,box_inner_size[1]/2+led_ring_offset,box_inner_size[2]+wall*2-button_h-$e])
                    cylinder(d=20,h=button_h);
            }

            // buttons cuts
            {
                for ( x = [-1,0,1] )
                translate([box_inner_size[0]/2+x*button_distance,box_inner_size[1]/2+button_offset,box_inner_size[2]+wall*2-button_h-$e]) {
                cylinder(d=button_d+clear*2,h=button_h);

                translate([-button_cut_w/2,-button_cut_d/2,0])
                cube([button_cut_w,button_cut_d,button_h]);
                }
            }

            // charger plate holder screw holes
            translate([box_inner_size[0]/2,box_inner_size[1]/2,0])
            for(i=[0:1:3])
            {
                rotate([0,0,i*90])
                    translate([-5,0,0]) {
                        l=box_inner_size[0]/2;

                        translate([0,l-5,0])
                        difference()
                        {
                            translate([5,$e-1,5])
                            rotate([-90,0,0]){
                                cylinder(d=screw_d,h=6);
                                translate([0,0,6-screw_h_head])
                                cylinder(d2=screw_d_head,d1=screw_d,h=screw_h_head);
                            }
                        }
                    }
            }

            // screw holes top plate
            {
                for(i=[0:90:359])
                {
                    translate([box_inner_size[0]/2,box_inner_size[1]/2,box_inner_size[2]-wall-$e])
                    rotate([0,0,i])
                    translate([box_inner_size[0]/2 - 8 ,box_inner_size[1]/2 - 8 ,0]) {
                        //cylinder(d1=screw_d_head,d2=screw_d,h=screw_h_head);

                        cylinder($fn=6,d=6.01+clear*2,h=3);
                        cylinder(d=screw_d,h=6+wall);
                    }

                }
            }
        }

        // main pcb placement
    }
}

module part_outer_box() {
    color("lightgreen")
    translate([softshell,softshell,softshell])
    difference() {
        cube([box_outer_size[0],
              box_outer_size[1],
              box_outer_size[2],
        ]);

        // inner cutout
        translate([wall,wall,wall]) {
            cube([box_outer_size[0]-wall*2,
                  box_outer_size[1]-wall*2,
                  box_outer_size[2]-wall+$e,
            ]);
        }

        // speaker holes
        intersection()
        {
            translate([box_outer_size[0]/2,wall+$e,box_outer_size[2]/2]) {
                rotate([90,0,0])
                cylinder(d=speaker_front_diameter,h=wall+$e*2);

            }
            for ( x = [0:1:8] )
            for ( y = [0:1:8] ) {
                speaker_hole_size=10;
                translate([x*(wall+speaker_hole_size)-wall/3,-$e,y*(wall+speaker_hole_size)-wall/4])
                cube([speaker_hole_size,wall+$e*2,speaker_hole_size]);
            }
        }

        // screw holes charger plate
        {
            translate([box_outer_size[0]/2,box_outer_size[1]/2,-$e]) {
                for(i=[80:360/5:359])
                rotate([0,0,i])
                translate([15,0,0])
                    cylinder(d=outer_charg_port_screw_d+0.7,h=wall+$e*2);

            }

        }

        // usb cut
        translate([box_outer_size[0]/2,box_outer_size[1]/2,-$e])
        {
            w=17;
            b=17;
            translate([10-w/2,-b/2,-$e])
                cube([w,b,10]);
        }

        // charger plug hole
        {
            translate([box_outer_size[0]/2,box_outer_size[1]/2,-$e]){
                cylinder(d=charger_plug_hole,h=wall+$e*2);
            }

        }
    }
}

module part_outer_charge_port() {
    d=40;
    d_squece=d+wall+25;

    squece_h=1;
    h=wall*2;
    h2=softshell-squece_h;
    translate([box_size[0]/2,box_size[1]/2,softshell]){
        difference()
        {
            union() {
                // base plate
                translate([0,0,-h])
                cylinder(d=d,h=h);

                // ring plate
                translate([0,0,-h2])
                difference() {
                    cylinder(d=d+wall,h=h2);
                    translate([0,0,-$e])
                        cylinder(d=d,h=h2+2*$e);
                }
                // ring plate
                translate([0,0,-h2])
                difference() {
                    {
                        translate([0,0,wall/2])
                        minkowski() {
                            cylinder(d=d_squece,h=$e);
                            sphere(d=wall-$e);
                        }
                    }
                    translate([0,0,-$e])
                        cylinder(d=d,h=h+2*$e);

                }
                // usb holder
                {
                    translate([15 + clear,-15/2,wall-h-$e])
                        cube([wall,15,16]);
                }

                translate([0,0,-wall*0.65])
                difference() {
                    ring=10;
                    translate([0,0,$e-h2+wall])
                    cylinder(d=d+ring,h=ring/2);
                    translate([0,0,ring-h2-wall])
                    rotate([0,0,0])
                    rotate_extrude(angle=360)
                        translate([d/2+ring*0.60,0,0])
                        circle(d=ring);

                        cylinder(d=d,h=100,center=true);
                }
            }

            // screw holes
            {
                translate([0,0,-h-$e]) {
                    for(i=[80:360/5:360])
                    rotate([0,0,i])
                    translate([15,0,0]) {
                        cylinder(d=outer_charg_port_screw_d,h=h+$e*2);
                        cylinder(d1=charg_port_screw_d_head,
                                 d2=charg_port_screw_d,
                                 ,h=charg_port_screw_h);
                    }
                }
            }

            // usb cut
            {
                // connector cut
                translate([12.2-1.5,-4,-h-$e])
                    cube([3,8,wall*2+$e*2]);
                // thining the wall for the plug
                translate([10.5-2,-15/2,-h-$e])
                    cube([7.5,15,4.1-1.5]);

                //screw cuts
                translate([15,4.5,13.5-h-$e])
                    rotate([0,90,0])
                        cylinder(d=screw_d,h=wall*3+$e*2);
                translate([15,-4.5,13.5-h-$e])
                    rotate([0,90,0])
                        cylinder(d=screw_d,h=wall*2+$e*2);

            }

            // charger mount
            {
                // cut through
                translate([0,0,-h-$e])
                    cylinder(d=w_charge_port[2]+clear*2,h=h+2*$e);
                translate([0,0,-h-$e])
                    cylinder(d=w_charge_port[3]+clear*2,h=h+2*$e-h_charge_port[3]);

            }
        }
    }
}

module part_inner_battery_holder() {
    d=50;
    h=5;
    translate([box_size[0]/2,box_size[1]/2,softshell+wall+clear])
    difference() {
        union() {
            // base plate
            translate([0,0,wall]) {
                //cylinder(d=38,h=h);
                w=37;d=35+12;
                translate([-w/2,-7-d/2])
                cube([w,d,wall]);
            }
            // base plate
            translate([0,0,0])
                cylinder(d=d,h=wall);

            // mounting arms
            for(i=[0:1:3])
            rotate([0,0,i*90]){
                translate([-5,0,0]) {
                    l=box_inner_size[1]/2-wall-clear;
                    hull() {
                        cube([10,l,wall]);
                        translate([-20,0,0])
                        cube([50,1,wall]);
                    }

                    translate([0,l-5,0])
                    difference()
                    {
                        cube([10,5,wall+7]);

                        translate([5,-$e,5])
                        rotate([-90,0,0]) {
                            cylinder(d=3,h=10);
                            cylinder($fn=6,d=6.01+clear*2,h=3);
                        }
                    }
                }
            }

            // charger pcb
            {
                translate([13,17.5,wall+0.5]) {
                    color("blue")
                    translate([0,0,-2*clear])
                    %rotate([0,0,90])
                        import("tp4056_micro_usb_18650_charger.STL");
                    translate([-30,17.5,-wall])
                    cube([30,wall,wall*2]);

                    translate([-30,17.5-0.4*wall,1])
                    cube([30,wall*1.4,wall]);
                }
            }



            // battery mount
            if (0) {
                bat_high=8;
                translate([wall*2,wall*2,wall*2+6])
                translate([0,0,20])
                rotate([0,0,45])
                {
                    difference() {
                        hull()
                        for ( x = [-1,1] )
                        for ( y = [-1,1] )
                        {

                            translate([x*47.5,y*16,-1.6-16])
                            cylinder(d=2.8+wall*2,h=wall);
                        }
                        // charge plug
                        {
                            translate([0,0,-1.6-8-$e])
                                cylinder(d=15,h=5+$e*2);

                        }
                    }

                    for ( x = [-1,1] )
                    for ( y = [-1,1] )
                    difference() {

                        translate([x*47.5,y*16,-1.6-16])
                        cylinder(d=2.8+wall*2,h=16);

                        translate([x*47.5,y*16,-5])
                        cylinder(d=2.8,h=500);

                    }
                    %color("orange")
                    import("Battery_Shield_V8.stl");
                }
            }else {

                difference() {
                    union() {
                        hull()
                        translate([0,0,0])
                        for(x=[-46.5,26.5])
                        for(y=[17,73.5])
                        translate([0, 0, $e])
                        translate([x+10.0,y-43.25,0]){
                            cylinder(d=10,h=wall);
                        }
                    }
                } /* diff screw holes */


                for(i=[-1,1])
                translate([0,0,0])
                translate([i*30,-32,0])
                rotate([0,0,90]) {
                    flexbatter18650(n=1,$fn=64);
                }
            } /* else */
        } /* union */

        // screw holder
        {
            translate([0,0,-$e]) {
                for(i=[80:360/5:359])
                rotate([0,0,i])
                translate([15,0,0]) {
                    cylinder(d=outer_charg_port_screw_d,h=h+$e*2);

                    translate([0,0,h+3-3+$e*2])
                    cylinder($fn=6,d=6.01+clear*2,h=3);
                }
            }
        }
        // charge plug
        {
            translate([0,0,-$e])
                cylinder(d=15,h=wall*2+$e*2);
        }
        // micro usb plug
        {
            w=17;
            b=17;
            translate([10-w/2,-b/2,-$e])
                cube([w,b,10]);
        }
    }
}

module part_outer_clamp() {
    translate([softshell,softshell,softshell]){
        h_clamp=10.5;
        h_clamp_sockel=5;
        color("lightgreen")
        translate([0,0,box_outer_size[2]-h_clamp-clear])
        difference() {
            hull() {
                cube([box_outer_size[0],
                      box_outer_size[1],
                      $e,
                ]);
                r=4;
                translate([-fabric,-fabric,h_clamp-$e*2-h_clamp_sockel])
                    minkowski() {
                    cube([box_size[0]-softshell-r*2,
                          box_size[0]-softshell-r*2,
                          $e]);
                        cylinder(r=r,h=h_clamp_sockel-$e);
                    }
            }

            // inner cutout
            diff=wall*2+fabric;
            translate([diff/2,diff/2,-$e]) {
                cube([box_outer_size[0]-diff,
                      box_outer_size[1]-diff,
                      h_clamp+$e*2+wall,
                ]);
            }
        }
    }
}

module part_charging_station() {
    d=40-2*0.5;
    d_plate=100;
    d_squece=d+wall+25;
    champfer=2;
    squece_h=1;
    h=10;
    h2=softshell-squece_h;
    cable_d=3;
    h_plate=cable_d+wall;
    translate([box_size[0]/2,box_size[1]/2,0]){
        difference()
        {
            union() {
                // chamfering cylinder
                hull() {
                    // base plate
                    translate([0,0,-h])
                    cylinder(d=d-champfer*2,h=h);

                    // base plate
                    translate([0,0,-h])
                    cylinder(d=d,h=h-champfer);
                }

                translate([0,0,-h-h_plate]){
                    hull() {
                        // base plate
                        cylinder(d=d_plate-champfer*2,h=h_plate);

                        // base plate
                        cylinder(d=d_plate,h=h_plate-champfer);
                    }
                }
            }

            // plug cutout
            h_pos_plug=-12;
            translate([0,0,h_pos_plug+2+$e])
            charge_plug(extra=0.25);
            hull() {
                translate([0,0,h_pos_plug+$e])
                charge_plug(extra=0.25,no_plug=true);

                translate([0,0,h_pos_plug-50])
                charge_plug(extra=0.25,no_plug=true);
            }

            // cable cutout
            translate([0,0,-h-h_plate+cable_d/2+cable_d-champfer])
            rotate([-90,0,0])
            cylinder(d=cable_d,h=d_plate);


            // cable cutout
            hull() {
            translate([0,18,-h-h_plate])
            rotate([10,0,0])
            cylinder(d=4,h=14);

            translate([0,10,-h-h_plate])
            rotate([10,0,0])
            cylinder(d=6,h=14);
            }

            // screw cuts
            translate([0,0,-h-$e]) {
                for(i=[0:360/3:360])
                rotate([0,0,i-90])
                translate([(d/4+d_plate-d)/2,0,-charg_port_screw_h+$e*2]) {
                    translate([0,0,-h+$e*2])
                    cylinder(d=outer_charg_port_screw_d,h=h+$e*2);
                    cylinder(d2=charg_port_screw_d_head,
                             d1=charg_port_screw_d,
                             ,h=charg_port_screw_h);
                }
            }

        }

    }
}

//////////////////////////////////////////////////////////
// display section


if(show_charging_station)
    part_charging_station();
if(show_top_plate)
    part_outer_plate();

if(show_top_infill)
    part_model_infill();

if(show_inner_box)
    part_inner_box();

if(show_outer_clampring)
    part_outer_clamp();

if(show_outer_box)
    part_outer_box();

if(show_charge_port_holder)
    part_inner_battery_holder();

if(show_charge_port_outer_part)
    part_outer_charge_port();


// non printing shows
%if(show_port) {
    translate([box_size[0]/2,box_size[1]/2,6])
        charge_port(wall*2+clear);
}

%if(show_speaker) {
    visatron();
}

%if(show_plug) {
    translate([box_size[0]/2,box_size[1]/2,-10+$e])
        charge_plug();
}
%if(show_buttons)
{
    for ( x = [-1,0,1] )
        translate([box_size[0]/2+x*button_distance,
                   box_size[1]/2+button_offset,
                   box_size[2]-softshell-21.5+clear])
        button_22("lightgreen");
}

%if(show_pcb_main) {
    translate([wall+clear+softshell+fabric,wall+clear+softshell+fabric,wall+clear+softshell])
    translate([22,box_inner_size[0]-wall,11])
    rotate([90,0,0]){
        subpart_pcb_holder();
        %translate([wall+clear,0,distance_behind_pcb+clear/2])
        pcb();
    }
}

%if(show_pcb_rfid){
    %
    translate([box_size[0]/2,box_size[1]/2+rfid_offset,box_size[2]-softshell])
    translate([18,-29,3-2.5])
    rotate([0,0,180])
    rotate([0,0,-90]) {
        color("blue")
        translate([10,17,0])
        rotate([180,0,0])
        import("Arduino RFID-RC522.stl");
    }

}
// non printing parts

module button_22(col="green"){
    color(col) {
        translate([0,0,24+3.5])
            cylinder(d=19.5,h=4);
        translate([0,0,24])
            cylinder(d=27,h=3.5);
        translate([0,0,24-14.5])
            cylinder(d=23.5, h=14.5);
    }
    color("silver") {
        translate([4.5,3-1.5,0])
            cube([0.5,3,24-14.5]);
        translate([4.5,-3-1.5,0])
            cube([0.5,3,24-14.5]);
    }
}


module usb_connector_pcb() {
    eps=0.01;
    usb_pcb_size=[15.6,13.3,1.6];

    difference() {
        union() {
            color("lightblue") {
                aligned_cube(usb_pcb_size, [0,1,0]);
            }


            //screw connectors plates
            color("silver") {
                for(i=[1,-1]) {
                    translate([9.3, i*4.5, -eps])
                        cylinder(d=3.5,h=usb_pcb_size[2]+eps*2);
                }
            }

            // pin connectors plates
            {
                names= [ "GND", "ID", "D+", "D-", "5V"];
                for(i=[0,1,2,3,4]) {
                    translate([9.3+4.81, (i-2)*2.54, -eps]) {
                        color("silver")
                        cylinder(d=1.5,h=usb_pcb_size[2]+eps*2);

                        color("black")
                        translate([-1.5,0,usb_pcb_size[2]])
                        linear_extrude(height = 2*eps)
                        rotate([0,0,90])
                        text(
                                halign="center",
                                valign="center",
                                size=0.75,
                                font=font,
                                names[i]
                        );
                    }
                }
            }
            // usb micro
            translate([0,0,usb_pcb_size[2]])
                usb_micro([0,1,0]);

        }

        //screw holes
        color("silver") {
            for(i=[1,-1]) {
                translate([9.3, i*4.5, -2*eps])
                    cylinder(d=3,h=usb_pcb_size[2]+eps*4);
            }
        }

        // pin connectors
        color("silver") {
            for(i=[-2,-1,0,1,2]) {
                translate([9.3+4.81, i*2.54, -2*eps])
                    cylinder(d=1,h=usb_pcb_size[2]+eps*4);
            }
        }
    }



}



module usb_micro(aligned=[2,1,0]) {

    color("Silver")
    difference() {
        size= [7.45, 6, 2.5];
        aligned_cube(size,aligned);

    }
}

module charge_port(h) {

    color("silver")
    difference() {
        union() {
            for(i=[0:4])
            cylinder(d=w_charge_port[i],h=h_charge_port[i]);
        }

        translate([0,0,-$e])
        cylinder(d=6,h=10);

    }
    color("gold")
    cylinder(d=2,h=10);

    // counter screw
    color("silver")
    translate([0,0,h])
    cylinder(d=17,h=2,$fn=6);

}
module charge_plug(extra=0,no_plug=false) {

    // metallic plug
    if(no_plug==false)
    translate([0,0,h_charge_plug[2]+2*extra])
    difference() {
        color("lightgray")
        translate([0,0,+$e]) {
            cylinder(d=w_charge_plug[0]+2*extra,h=h_charge_plug[0]+extra-$e);
        }

        color("gold")
        translate([0,0,h_charge_plug[1]+extra])
        cylinder(d=w_charge_plug[1]+extra*2,h=h_charge_port[0]-h_charge_plug[1]+extra+$e);
    }
    // plastic part
    color("gray")
    cylinder(d=w_charge_plug[2]+2*extra,h=h_charge_plug[2]+extra);

    translate([-h_charge_plug[3]/2-extra,extra,0])
    cube([h_charge_plug[3]+2*extra,w_charge_plug[3]+2*extra,h_charge_plug[3]+extra]);
}

module pcb() {
    difference(){
        color("darkgray")
        cube(pcb_main_size);

        translate([pcb_main_size[0]-4,4,-$e])
        cylinder(d=3,h=pcb_main_size[2]+$e*2);

        translate([4,pcb_main_size[1]-4,-$e])
        cylinder(d=3,h=pcb_main_size[2]+$e*2);
    }
}

module visatron()  {
    color("brown")
    // visatron
    %translate([wall+clear+softshell+fabric,wall+clear+softshell+fabric,wall+clear+softshell])
    translate([box_inner_size[0]/2,wall+$e,box_inner_size[2]/2]) {
        rotate([90,0,180])
        difference() {
            union() {
                hull() {
                    cylinder(d=52,h=2);
                    for ( i = [-1,1] )
                        translate([i*(68-5)/2,0,0])
                        cylinder(d=5,h=2);
                }
                cylinder(d=42,h=33);
            }


            for ( i = [-1,1] )
            translate([speaker_screw_dist*0.5*i,0,0])
            {
                cylinder(d=screw_d,h=2+$e*2);
            }
        }
    }
}

// helper functions

module aligned_cube(size, aligned=[1,1,0]){
    translate(-0.5*[size[0]*aligned[0], size[1]*aligned[1], size[2]*aligned[2]])
        cube(size);
}
