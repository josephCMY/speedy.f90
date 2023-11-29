!> author: Man-Yau Chan
!  date: 11/28/2023
!  Applies stochastic perturbations to the initial rest state
!  These perturbations are currently limit to temeprature perturbations
module perturb_init_conditions

    use types, only: p
    use params
    use prognostics, only: t


contains


    ! Subroutine that adds temperature perturbations
    subroutine apply_temperature_perturbations()

        implicit none

        real(mx,nx,kx,2) :: noise_array
        real             :: noise_level = 0.001  ! --- Std dev of perturbations
        real             :: PI

        ! Compute PI
        PI = 4*ATAN(1.d0)

        ! Seed the random number generator
        call RANDOM_SEED( put=random_init_seed )

        ! Draw noise from uniform random distribution
        call RANDOM_NUMBER( noise_array )

        ! Convert uniform random noise into standard normal noise
        ! Done via the Box-Muller transform
        noise_array(:,:,:,1) = SQRT( - 2 * LOG( noise_array(:,:,:,1) ) ) * COS( 2 * PI * noise_array(:,:,:,2) )
        
        ! Rescale noise to desired level
        noise_array(:,:,:,1) = noise_array(:,:,:,1) * noise_level
        
        ! Apply noise to temperature array
        t(:,:,:,1) = t(:,:,:,1) + noise_array(:,:,:,1)


    end subroutine apply_temperature_perturbations




end module perturb_init_conditions

