module mod_initgrid
  use mod_param, only:pi
  implicit none
  private
  public initgrid
  contains
  subroutine initgrid(inivel,n,gr,lz,dzc,dzf,zc,zf)
    !
    ! initializes the non-uniform grid in z
    !
    implicit none
    character(len=3) :: inivel
    integer, intent(in) :: n
    real(8), intent(in) :: gr,lz
    real(8), intent(out), dimension(0:n+1) :: dzc,dzf,zc,zf
    real(8) :: z0
    integer :: k
    procedure (), pointer :: gridpoint => null()
    select case(inivel)
    case('zer','log','poi','cou')
      gridpoint => gridpoint_cluster_two_end
    case('hcl','hcp')
      gridpoint => gridpoint_cluster_one_end
    case default
      gridpoint => gridpoint_cluster_two_end
    end select
    !
    ! step 1) determine coordinates of cell faces zf
    !
    do k=1,n
      z0  = (k-0.d0)/(1.d0*n)
      call gridpoint(gr,z0,zf(k))
      zf(k) = zf(k)*lz
    enddo
    zf(0) = 0.d0
    !
    ! step 2) determine grid spacing between faces dzf
    !
    do k=1,n
      dzf(k) = zf(k)-zf(k-1)
    enddo
    dzf(0  ) = dzf(1)
    dzf(n+1) = dzf(n)
    !
    ! step 3) determine grid spacing between centers dzc
    !
    do k=0,n
      dzc(k) = .5d0*(dzf(k)+dzf(k+1))
    enddo
    dzc(n+1) = dzc(n)
    !
    ! step 4) compute coordinates of cell centers zc and faces zf
    !
    zc(0)    = -dzc(0)/2.d0
    zf(0)    = 0.d0
    do k=1,n+1
      zc(k) = zc(k-1) + dzc(k-1)
      zf(k) = zf(k-1) + dzf(k)
    enddo
    return
  end subroutine initgrid
  !
  ! grid stretching functions 
  ! see e.g., Fluid Flow Phenomena -- A Numerical Toolkit, by P. Orlandi 
  !
  subroutine gridpoint_cluster_two_end(alpha,z0,z)
    !
    ! clustered at the two sides
    !
    implicit none
    real(8), intent(in) :: alpha,z0
    real(8), intent(out) :: z
    if(alpha.ne.0.d0) then
      z = 0.5d0*(1.d0+tanh((z0-0.5d0)*alpha)/tanh(alpha/2.d0))
    else
      z = z0
    endif
    return
  end subroutine gridpoint_cluster_two_end
  subroutine gridpoint_cluster_one_end(alpha,z0,z)
    !
    ! clustered at the lower side
    !
    implicit none
    real(8), intent(in) :: alpha,z0
    real(8), intent(out) :: z
    if(alpha.ne.0.d0) then
      z = 1.0d0*(1.d0+tanh((z0-1.0d0)*alpha)/tanh(alpha/1.d0))
    else
      z = z0
    endif
    return
  end subroutine gridpoint_cluster_one_end
  subroutine gridpoint_cluster_middle(alpha,z0,z)
    !
    ! clustered in the middle
    !
    implicit none
    real(8), intent(in) :: alpha,z0
    real(8), intent(out) :: z
    if(alpha.ne.0.d0) then
      if(    z0.le.0.5d0) then 
        z = 0.5d0*(1.d0-1.d0+tanh(2.d0*alpha*(z0-0.d0))/tanh(alpha))
      elseif(z0.gt.0.5d0) then
        z = 0.5d0*(1.d0+1.d0+tanh(2.d0*alpha*(z0-1.d0))/tanh(alpha))
      endif
    else
      z = z0
    endif
    return
  end subroutine gridpoint_cluster_middle
end module mod_initgrid
