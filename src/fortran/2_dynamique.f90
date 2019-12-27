Module utilsFunctions
    implicit none
    contains
    
    subroutine v_compute_min_max(v_in, s, v_min, v_max)
        implicit none
        integer, intent(in) :: s
        real, dimension(0:s-1), intent(in) :: v_in
        real, intent(out) :: v_min, v_max

        integer :: i
        real :: tmp

        v_min = v_in(0)
        v_max = v_in(0)

        do i=1,s-1
            tmp = v_in(i)

            if(tmp > v_max) then
                v_max = tmp
            else if (tmp < v_min) then
                v_min = tmp
            end if
        end do
   
    end subroutine v_compute_min_max
end module utilsFunctions


subroutine img_stretch_intensity(img_in, W, H, img_out)
    use utilsFunctions
    implicit none
    integer, intent(in) :: W, H
    real, dimension(1:W*H), intent(in) :: img_in
    real, dimension(1:W*H), intent(out) :: img_out

    real :: min, max
    real, parameter :: a1 = 0, a2 = 255

    call v_compute_min_max(img_in, W*H, min, max)
    ! intrinsic functions for the same result
    ! min = minval(img_in)
    ! max = maxval(img_in)

    if(max /= min) then
        img_out = a1 + (a2 - a1) / (max - min) * (img_in - min)
    else
        img_out = (a1 + a2) / 2.0
    end if
end subroutine img_stretch_intensity

