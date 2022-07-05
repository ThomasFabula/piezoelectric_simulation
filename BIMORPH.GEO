/COM *********************************************************
/COM
/COM File: BIMORPH.GEO 
/COM
/COM *********************************************************
/COM Microactuator: Silicon diaphrgam with piezoceramic
/COM *********************************************************
/COM Material properties must be loaded first:
/COM    /INP,BIMORPH,MAT
/COM *********************************************************
/TITLE, Piezoelectric BIMORPH Microactuator

/COM ******** material properties for Si<110> direction
SIEM=1.689e11      ! average Young's modulus [N/m2]
SIPO=0.0625        ! average Poisson's ratio
SIRO=2329          ! material density [kg/m3]

/COM ******** assign material properties
MP,EX,1,SIEM
MP,NUXY,1,SIPO
MP,DENS,1,SIRO

/COM ******** geoemtric parameters
LANG=4.6e-3        ! half of diaphragm side length [m]
DICK=20e-6         ! thickness of silicon diaphragm [m]
DPIZ=200e-6        ! thickness of piezoceramic [m]
ZANZ=1             ! number of elements: vertikal
XANZ=10            ! number of elements: horizontal
XINC=LANG/XANZ     ! element size: horizontal [m]
ZINC=DICK/ZANZ     ! element size: vertikal [m]
dges=dick+dpiz

/COM ******** define two different element types
et,1,45 ! solid element: 8 nodes, DOFs: UX,UY,UZ
et,2,5  ! multi-field elem., 8 nodes, DOFs: UX,UY,UZ,TEMP,VOLT,MAG

/COM ******** define geometry

/COM ============== silicon diaphragm =======================
n,1                             ! generate first node line
n,xanz+1,lang
fill
ngen,xanz+1,xanz+1,all,,,,xinc  ! generate bottom node row
ngen,zanz+1,1000,all,,,,,zinc   ! generate further node rows

/COM ******** define elements
mat,1                           ! material:     no. 1
type,1                          ! element type: no. 1
e,1,2,xanz+3,xanz+2,1001,1002,1000+xanz+3,1000+xanz+2
egen,xanz,1,all
egen,xanz,xanz+1,all
egen,zanz,1000,all

/COM ============== piezoceramic (1 layer) ===================
n,2001,,,dges                   ! generate nodes
n,2011,lang,,dges
fill
ngen,11,11,2001,2011,1,,xinc

/COM ******** define elements
mat,3                           ! material:     no. 2
type,2                          ! element type: no. 2
e,1001,1002,1013,1012,2001,2002,2013,2012
egen,xanz,1,-1
egen,xanz,xanz+1,-10

/COM ******** define geoemtric boundary conditions
allsel                ! fix all outer nodes of silicon diaphragm
nsel,s,loc,z          ! but leave piezoceramic mechanical free
nsel,r,loc,x
d,all,ux
d,all,uy
d,all,uz
nsel,s,loc,z
nsel,r,loc,y,lang
d,all,ux
d,all,uy
d,all,uz
allsel

/COM ******** symmetry conditions
LOCAL,11,0,lang
nsel,s,loc,x
DSYMM,symm,x,11
nsel,s,loc,y
DSYMM,symm,y,11
allsel

/COM ******** ANSYS-options
/pnum,mat,1    ! show all materials
/pbc,all,1     ! show all boundary conditions
/view,1,1,1,1  ! define view
CSYS           ! activate first coordinate system
wsort          ! reorder elements
save           ! save model data for further RESUME

/COM ******************************************************************
/COM read analysis files with following commands:
/COM
/COM   /INP,BIM-K0,ANL - STATIC ANALYSIS     or
/COM
/COM   /INP,BIM-K2,ANL - MODAL ANALYSIS
/COM
/COM ****************************************************************** 
