"""
fix_static_driver.py
Fixes PALM static driver to have nz+2 z-levels required by topography_mod.
Usage: python3 fix_static_driver.py <input_static> <output_static> <nz>
Example: python3 fix_static_driver.py ccny_static ccny_static_fixed 100
"""
import sys
import netCDF4 as nc
import numpy as np

src = sys.argv[1]
dst = sys.argv[2]
nz = int(sys.argv[3])
nz_new = nz + 2
dz = 5.0
new_z = np.array([0.0] + [dz/2 + k*dz for k in range(nz_new-1)])

with nc.Dataset(src, 'r') as si, nc.Dataset(dst, 'w', format='NETCDF4') as so:
    so.setncatts({a: si.getncattr(a) for a in si.ncattrs()})
    for name, dim in si.dimensions.items():
        so.createDimension(name, nz_new if name == 'z' else len(dim))
    for name, var in si.variables.items():
        fill = var._FillValue if hasattr(var, '_FillValue') else False
        v = so.createVariable(name, var.dtype, var.dimensions, fill_value=fill)
        v.setncatts({a: var.getncattr(a) for a in var.ncattrs() if a != '_FillValue'})
        if name == 'z':
            v[:] = new_z
        elif name == 'buildings_3d':
            old = var[:]
            new = np.zeros((nz_new, old.shape[1], old.shape[2]), dtype=old.dtype)
            new[:old.shape[0]] = old
            v[:] = new
        else:
            v[:] = var[:]

print(f"Done. New z shape: {nz_new}, buildings_3d shape: ({nz_new}, {old.shape[1]}, {old.shape[2]})")
