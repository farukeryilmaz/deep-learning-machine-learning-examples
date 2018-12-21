# Setting The Environment

Software and libraries:
- Anaconda Python 3.7
- Tensorflow
- Keras
- OpenAI Gym

Platform I have tested on: OpenSuse Leap 15 (but distributions like Ubuntu or based on Ubuntu might be less painfull)

## Anaconda Python 3.7

To download anaconda: 
- newest: https://www.anaconda.com/download/#linux
- the one I used: https://repo.continuum.io/archive/Anaconda3-5.3.1-Linux-x86_64.sh

to install:
```
$ chmod +x Anaconda3-5.3.1-Linux-x86_64.sh
$ ./Anaconda3-5.3.1-Linux-x86_64.sh

$ conda --version
# example output -> conda 4.5.11
```

## Setting Anaconda Environment

Instead of using the default Anaconda environment, we create a separate environment. Let's check the installed media first:

```
$ conda env list

Example output:

# conda environments:
#
base                  *  /home/faruk/anaconda3
```

Let's create new anaconda environment:

```
$ conda create --name deeplearning anaconda python=3.6
```

**Tensorflow supports currently python 3.6 so it is important to create py3.6 environment.**
*"anaconda" is the metapackage that includes all of the Python packages comprising the Anaconda distribution. python=3.6 is the package and version you want to install in this new environment. This could be any package, such as numpy=1.7, or multiple packages.*

Once the necessary downloads have been made, let's check if the environment has been installed:

```
$ conda env list

Example output:

# conda environments:
#
base                  *  /home/faruk/anaconda3
deeplearning             /home/faruk/anaconda3/envs/deeplearning
```

The asterisk sign indicates the currently active environment. To switch to "deeplearning" (to enable this environment), enter the following command:

```
$ source activate deeplearning
```

After doing this, you will see (deeplearning) at the beginning of the shell entry. If you enter **conda env list** again, this time the star will indicate that deeplearning environment is active.

To exit from the environtment:

```
$ source deactivate
```

## Tensorflow and Keras

First, if the environment is passive, activate the deeplearning environment. Then enter the following command to install Tensorflow and Keras packages:

```
$ conda install -c conda-forge keras tensorflow
```

Tensorflow and Keras packages will be installed. To check if packages are installed, give the following command:

```
$ conda list | grep 'tensorflow\|keras'

Example output:

keras                     2.2.4                    py36_0    conda-forge
keras-applications        1.0.4                      py_1    conda-forge
keras-preprocessing       1.0.2                      py_1    conda-forge
tensorflow                1.10.0                   py36_0    conda-forge
```

## OpenAI Gym

You need to install/set up dependencies first.

**OpenSuse Leap 15:**

```
$ sudo zypper install cmake libav-tools librhash0 libuv1 python3-devel python3-opengl python3-opengl-accelerate python2-opengl python2-opengl-accelerate python3-numpy swig zlib-devel libjpeg8 libjpeg8-devel libjpeg8-32bit libjpeg8-devel-32bit xvfb-run xorg-x11-devel libboost*devel ghc-sdl2 ghc-sdl2-devel python3-glfw python2-glfw libglfw3 libglfw3 glfw2-devel libglfw-devel python3-imageio python2-imageio python-cffi python2-lockfile python3-lockfile python2-Cython python3-Cython python2-Pillow python3-Pillow
```

**To install dependencies on Ubuntu and its variants, use the following command:**

```
$ sudo apt-get install -y python-numpy python-dev libboost-all-dev libsdl2-dev swig cmake zlib1g-dev libjpeg-dev xvfb libav-tools xorg-dev python-opengl
```

Then, enter the following commands in order to install the Gym package (make sure the deeplearning environment is activated):

```
$ pip install ImageHash ipdb pytest pytest-instafail scipy sphinx sphinx_rtd_theme numpydoc PyHamcrest
$ pip install 'gym[all]'
```

**current packets can be mismatched between old dependencies. if you cannot solve errors, try to download old packages, try this:**

```
$ pip install gym==0.9.4
```

To verify that the package is installed, enter the following command:

```
$ pip freeze | grep gym

At least one of the lines have to be gym. Sample output:

gym==0.9.4
```

If you get error while trying to run "jupyter notebook" (**OSError: [Errno 99] Cannot assign requested address**) you can try:

```
$ jupyter notebook --ip=127.0.0.1
```
