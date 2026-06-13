"""
VIBRIT420 Piezoceramic Material Definition (Siemens 1981)
Modernized for PyMAPDL / ANSYS 2020 R1+
"""

import numpy as np
from ansys.mapdl.core import launch_mapdl

# ====================== MATERIAL PARAMETERS ======================
MAT_ID = 3
DENSITY = 7594.3          # kg/m³

# Elastic stiffness matrix [C] in Pa (N/m²)
C11 = 1.092e11
C12 = 0.6178e11
C13 = 0.5485e11
C33 = 0.8867e11
C44 = 0.2222e11
C66 = 0.2370e11

# Piezoelectric coefficients [e] in C/m²
E31 = -7.853
E33 = 13.93
E15 = -11.67

# Relative permittivity
EPS_R11 = 1600
EPS_R33 = 1600

print("=== Defining VIBRIT420 Piezoceramic (Material", MAT_ID, ") ===")

# Launch MAPDL (or connect to existing session)
mapdl = launch_mapdl()
mapdl.prep7()

# ====================== MATERIAL DEFINITION ======================

# 1. Density
mapdl.mp("DENS", MAT_ID, DENSITY)

# 2. Elastic Stiffness Matrix (Anisotropic)
mapdl.tb("ANEL", MAT_ID)   # Anisotropic elastic material

# Fill upper triangle of stiffness matrix
mapdl.tbdata(1, C11, C12, C13, 0, 0, 0)
mapdl.tbdata(7, C11, C13, 0, 0, 0)
mapdl.tbdata(13, C33, 0, 0, 0)
mapdl.tbdata(19, C44, 0, 0)
mapdl.tbdata(25, C66)

# 3. Piezoelectric Stress Matrix [e]
mapdl.tb("PIEZ", MAT_ID, "", "", "L2")   # e-matrix in stress form

mapdl.tbdata(1,  0,     0,     E31)      # Row 1
mapdl.tbdata(4,  0,     0,     E31)      # Row 2
mapdl.tbdata(7,  0,     0,     E33)      # Row 3
mapdl.tbdata(10, E15,   0,     0)        # Row 4 (shear)
mapdl.tbdata(13, 0,     E15,   0)        # Row 5
mapdl.tbdata(16, 0,     0,     0)        # Row 6

# 4. Dielectric Permittivity
eps0 = 8.854187817e-12                   # F/m
mapdl.mp("PERX", MAT_ID, EPS_R11 * eps0)
mapdl.mp("PERY", MAT_ID, EPS_R11 * eps0)
mapdl.mp("PERZ", MAT_ID, EPS_R33 * eps0)

# 5. Dummy properties (to suppress warnings)
mapdl.mp("MURX", MAT_ID, 1.0)
mapdl.mp("KXX",  MAT_ID, 1.0)

print(f"Material {MAT_ID} (VIBRIT420) successfully defined.")

# Optional: Verify material
mapdl.mplist(MAT_ID)

----------------------------------------


Key Modernization Changes
-------------------------
Old APDL                    Modern PyMAPDL                    Benefit
tb,anel + manual tbdata      tb("ANEL") + clear matrix         Cleaner & safer
ecc=1e9 scaling              Direct physical units (C/m²)      No artificial scaling
mp,perx etc.                 Same, but clearer                 Better readability
Hard-coded numbers           Named constants                   Easy to maintain





