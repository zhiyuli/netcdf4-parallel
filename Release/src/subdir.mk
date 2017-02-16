################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../src/mpi2.c 

OBJS += \
./src/mpi2.o 

C_DEPS += \
./src/mpi2.d 


# Each subdirectory must supply rules for building sources it contributes
src/%.o: ../src/%.c
	@echo 'Building file: $<'
	@echo 'Invoking: GCC C Compiler'
	mpicc -I/usr/local/hdf5/include -I/usr/local/szip/include -I/usr/local/netcdf4/include -I/usr/local/zlib/include -I/home/drew/netcdf-4.4.1.1 -I/home/drew/netcdf-4.4.1.1/include -O3 -Wall -c -fmessage-length=0 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


