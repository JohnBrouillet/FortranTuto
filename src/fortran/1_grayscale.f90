module Grayscale
    contains
    subroutine grayscaleCStyle(data, W, H, channel, output)
        implicit none
        integer, intent(in) :: W, H, channel
        real, dimension(1:W*H*channel), intent(in) :: data
        real, dimension(1:W*H), intent(out) :: output

        integer :: i, j
        real :: t1, t2

        j = 0
        call cpu_time(t1)
        do i=1,W*H
            output(i) = 0.30*data(i+j+2) + 0.59*data(i+j+1) + 0.11*data(i+j)
            j = j+2
        end do
        call cpu_time(t2)
        print*, "Grayscale, naive method : ", t2 - t1, "s"
    end subroutine grayscaleCStyle

    subroutine grayscaleFortran(data, W, H, channel, output)
        implicit none
        integer, intent(in) :: W, H, channel
        real, dimension(1:W*H*channel), intent(in) :: data
        real, dimension(1:W*H), intent(out) :: output

        real, dimension(channel, W*H) :: pixels, coeffTab
        real, dimension(3) :: coeff = [0.11, 0.59, 0.30]
        real :: t1, t2

        coeffTab = spread(coeff, dim=2, ncopies=W*H)
        pixels = reshape(data, (/channel, W*H/))
        call cpu_time(t1)

        output = sum(coeffTab*pixels, dim=1)

        call cpu_time(t2)
        print*, "Grayscale, fortran method: ", t2 - t1, "s"
    end subroutine grayscaleFortran

end module Grayscale

subroutine s_grayscale(data, W, H, channel, output)
    use Grayscale
    implicit none
    integer, intent(in) :: W, H, channel
    real, dimension(1:W*H*channel), intent(in) :: data
    real, dimension(1:W*H), intent(out) :: output

    call grayscaleCStyle(data, W, H, channel, output)
    call grayscaleFortran(data, W, H, channel, output)
    
end subroutine s_grayscale