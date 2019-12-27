subroutine s_grayscale(data, W, H, channel, output)
    implicit none
    integer, intent(in) :: W, H, channel
    real, dimension(1:W*H*channel), intent(in) :: data
    real, dimension(1:W*H), intent(out) :: output
    
    integer :: i, j
   
    j = 0
    do i=1,W*H
        output(i) = 0.30*data(i+j+2) + 0.59*data(i+j+1) + 0.11*data(i+j)
        j = j+2
    end do
end subroutine s_grayscale