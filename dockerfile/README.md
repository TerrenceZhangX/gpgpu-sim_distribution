# Docker File Notice

Currently there's an unkown bug causing python tests to fail as configuration sm version(V100, which is sm70) lower than test version(sm75). However, if you `source setup_envrionment` then `make -j32`, this issue can be solved.

Run `../bmm.py` under `/tests/matmul` folder since there exists an configuration file.