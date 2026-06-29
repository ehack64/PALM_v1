# CCNY Urban LES Case

## Overview

High-resolution LES simulation of urban flow over the City College of New York (CCNY) neighborhood in Manhattan.

## Domain

- Grid: 200 x 200 x 100 points
- Resolution: 5m x 5m x 5m
- Physical size: 1km x 1km x 500m
- Location: 40.818N, -73.949W

## Simulation Settings

- Start: 2025-07-01 06:00 UTC
- End time: 43200s (12 hours)
- Spinup: 1800s
- Geostrophic wind: U=3.0 m/s, V=0.0 m/s
- Radiation: RRTMG
- Land surface: enabled
- Urban surface: enabled

## Required Input Files

- ccny_p3d — namelist parameter file
- ccny_static — static driver (buildings, surface types)
- ccny_rlw — RRTMG longwave input
- ccny_rsw — RRTMG shortwave input

## Static Driver Notes

The static driver must have 102 z-levels (nz+2=102 for nz=100).
To fix an existing static driver:

```python
import netCDF4 as nc
import numpy as np

src = 'ccny_static_original'
dst = 'ccny_static'
nz_new = 102
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
```

## Running the Case

```bash
sbatch ~/palm/JOBS/ccny/ccny_slurm.sh
```

Monitor progress:
```bash
tail -f ~/palm/JOBS/ccny/slurm_XXX.out
cat ~/palm/tmp/ccny.XXXXX/RUN_CONTROL
```

## Output Files

- ccny_3d.000.nc — 3D instantaneous fields (1.9GB)
- ccny_av_3d.000.nc — 3D time-averaged fields (374MB)
- ccny_av_xy.000.nc — XY cross-sections averaged (3.7MB)
- ccny_pr.000.nc — vertical profiles (33KB)
- ccny_ts.000.nc — time series (32KB)
- ccny_xy.000.nc — XY cross-sections instantaneous (11MB)
