/COM **********************************************************
/COM
/COM File: ACCEL.GEO
/COM
/COM **********************************************************
/COM
/COM **********************************************************
/COM Structure of a capacitive acceleration sensor:
/COM **********************************************************
/COM
/COM Model based on 3-D solid elements (STIF45)
/COM
/TITLE, Capacitive acceleration sensor
/COM
/COM --------- Definition of analysis type with special options
/COM
antype,static        ! static analysis
/COM
/COM ----------------------- Options for graphic display
/COM
/pbc,all,1           ! all boundary conditions will be displayed
/PNUM,KPOI,1         ! show numbered keypoints
/PNUM,LINE,1         ! show numbered lines
/PNUM,AREA,1         ! show numbered areas
/PNUM,VOLU,1         ! show numbered volumes
/vup,,z              ! defines the orientation of
                     ! the display coordinate system
/VIEW,,-1,1,1        ! defines the viewing direction
/TYPE,,HIDD          ! hidden line display
/COM
/COM
/COM  -------- Auxiliary parameters for definition of keypoints
/COM
del1=((diez-beaz)/1.41)
del2=beaz/1.41
seix=seix+2*del1
seiy=seiy+2*del1
frax=frax+del1
x1 = 0
x2 = seix
x3 = x2+beax
x4 = x3+frax
y1 = beay/2
y2 = seiy/2+y1
y3 = fray/2+y1
z1 = 0
/COM
/COM ------------------------- End of the parameter definitions
/COM
/COM ******************************************* Solid Modeling
/COM
/COM -------------Generation of keypoints and line connections
/COM
k,1,x1,y1,z1      ! keypoints on top of the structure
k,2,x2,y1,z1      ! will be defined ...
k,3,x3,y1,z1
k,4,x4,y1,z1
/COM
l,1,2             ! line connection from keypoint 1 to 2
l,2,3             ! line connection from keypoint 2 to 3
l,3,4             ! line connection from keypoint 3 to 4
/COM
/COM --------------- Generation of line divisions and new lines
/COM                     by copying a given pattern of lines
/COM
lesize,1,,,sdix         ! "sdix" divisions along line 1
lesize,2,,,bdix         ! a.s.o....
lesize,3,,,fdix
/COM
lgen,2,all,,,,,-beaz,20   ! copying given lines in z-direction
                          ! with increment -beaz, the increment
                          ! applied to each keypoint number is 20,
                          ! line divisions will be also copied
lgen,2,1,3,1,,,-diez,30   ! copying the given lines 1 to 3 in
                          ! z-direction with increment -diez,
                          ! keypoint increment is 30
ldel,8                    ! delete line 8
l,1,21                    ! line connections between the initial
l,2,22                    ! and the first copied line pattern ...
l,3,23
l,4,24
lesize,all,,,bdiz         ! line divisions of the new connections
/COM
l,21,31                   ! cross connections of the 2nd and 3rd
l,22,32                   ! generated line pattern
l,23,33
l,24,34
/COM
lesize,15,,,fdiz          ! line divisions of the frame
lesize,16,,,fdiz          ! in z-direction
lesize,all,,,sdiz         ! line divisions of the seismic mass
                          ! in z-direction
/COM
/COM -------------- Modification of keypoint locations referred
/COM                to the (111)-slope of the silicon structure
/COM
kmodif,31,x1+del1     ! the x-coordinate of keypoint 31 is
                      ! modified to "x1+del1"
kmodif,32,x2-del1     ! further modifications...
kmodif,33,x3+del1
/COM
/COM ----------------------- Generation of areas
/COM
A,1,21,22,2           ! generation of an area through the
                      ! existing keypoints 1,21,22,2
A,2,22,23,3           ! (cross-sectional areas)...
A,3,23,24,4
A,21,31,32,22
A,23,33,34,24
/COM
/COM ------- Generation of volumes through up of existing areas
/COM
k,100,,-y1       ! auxiliary keypoints will be defined...
k,101,,-y2
k,102,,y2
k,103,,-y3
k,104,,+y3
l,1,100          ! auxiliary line connections of the predefined
l,100,101        ! keypoints...
l,1,102
l,100,103
l,1,104
lesize,17,,,bdiy      ! divisions of all the auxiliary lines...
lesize,18,,,sdiy
lesize,19,,,sdiy
lesize,20,,,fdiy
lesize,21,,,fdiy
/COM
VDRAG,1,2,3,4,5,,17   ! generates volumes by dragging a pattern
                      ! of areas (area 1,2,3,4,5 parallel to the
                      ! path defined by line 17)
VDRAG,10,22,,,,,18    ! generates volumes of the seismic mass
VDRAG,1,4,,,,,19      ! in -y- and +y-direction...
VDRAG,3,5,,,,,21      ! generates the volume of the frame...
VDRAG,18,26,,,,,20
/COM
/COM -------------- Modification of keypoint locations referred
/COM                to the (111)-slope of the silicon structure
/COM
kmodif,25,,-y2+del1        ! keypoints of the seismic mass (bottom)...
kmodif,26,,-y2+del1
kmodif,35,,y2-del1
kmodif,36,,y2-del1
ksel,s,loc,y,y1            ! keypoints in y-direction...
ksel,r,loc,z
kmodif,all,,y1-del2
ksel,s,loc,y,-y1
ksel,r,loc,z
kmodif,all,,-y1+del2
ksel,s,loc,y,y2
ksel,r,loc,z
kmodif,all,,y2-del2
ksel,s,loc,y,-y2
ksel,r,loc,z
kmodif,all,,-y2+del2
ksel,s,loc,x,x1            ! keypoints in x-direction...
ksel,r,loc,z
kmodif,all,x1+del2
ksel,s,loc,x,x2
ksel,r,loc,z
kmodif,all,x2-del2
ksel,s,loc,x,x3
ksel,r,loc,z
kmodif,all,x3+del2
allsel
/COM
/COM
/COM
/COM ------------------ Meshing of the volumes
/COM
MAT,1                 ! material reference number 1 is
                      ! assigned to elements subsequently
                      ! defined
ET,1,ELTY             ! allocation of the element type "ELTY"
VMESH,all             ! meshing of all volumes
/COM
/COM ------------------------- Definition of boundary conditions
/COM
nsel,s,loc,z,-diez    ! selects nodes on the bottom
nsel,r,loc,x,x3,x4    ! of the frame...
d,all,all             ! all degrees of freedom of the selected
                      ! nodes are determined
allsel                ! reselects all nodes, elements, keypoints, ...
/COM
/COM ------------------------- Definition of loads
/COM
ACEL,acx,acy,acz      ! defines accelerations in x-,y-,z-Richtung
wsort                 ! reorders elements based on a sort of
                      ! element locations
eplo,ext              ! displays all the external elements
                      ! of the model
/COM
/COM **********************************************************
/COM Before the preprocessing phase is finished you can look
/COM for some model properties, like keypoints, lines, areas,
/COM volumes (geometric model) or elements, nodes (FE-model)
/COM using some available graphic commands. A few helpful
/COM commands you will find in the seperately distributed
/COM command appendix.
/COM
/COM
/COM Next step: The preprocessing phase will be finished and the
/COM            solution phase have to be started using the
/COM            following command sequence:
/COM
/COM            ***********************************************
/COM            *  fini    ! Preprocessing phase is finished  *
/COM            *  /solu   ! Entering the solution mode       *
/COM            *  solve   ! Start the solution               *
/COM            ***********************************************
/COM
/COM The solution phase will stop with the last line.
/COM Now the equilibrium equations are solved and
/COM the solution phase can be finished with the following
/COM input:
/COM                    **********
/COM                    *  fini  *
/COM                    **********
/COM
/COM Returned to the "BEGIN-level", you will entry the
/COM postprocessing using the predefined macro "ACCEL.POS":
/COM
/COM                    ********************
/COM                    *  /inp,accel,pos  *
/COM                    ********************
/COM **********************************************************
