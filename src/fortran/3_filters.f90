module abstract_filters
    abstract interface
        function abstractfilter(tab, s)
            integer, intent(in) :: s
            real, dimension(s), intent(in) :: tab
            real :: abstractfilter
        end function abstractfilter
    end interface
end module abstract_filters

module filters
    contains
    function vmoy(tab, s)
        implicit none
        integer, intent(in) :: s
        real, dimension(s), intent(in) :: tab
        real :: vmoy

        vmoy = sum(tab) / s
    end function vmoy

    function vmin(tab, s)
        implicit none
        integer, intent(in) :: s
        real, dimension(s), intent(in) :: tab
        real :: vmin

        vmin = minval(tab)
    end function vmin

    function vmax(tab, s)
        implicit none
        integer, intent(in) :: s
        real, dimension(s), intent(in) :: tab
        real :: vmax

        vmax = maxval(tab)
    end function vmax
end module filters

module filterProcess
    use abstract_filters
    use filters
    implicit none
    contains
        subroutine processCStyle(img_in, W, H, TX, TY, f, img_out)
            implicit none
            procedure(abstractfilter) :: f
            integer, intent(in) :: W, H, TX, TY
            real, dimension(0:W*H-1), intent(in) :: img_in
            real, dimension(0:W*H-1), intent(out) :: img_out

            real, dimension(0:TX*TY-1) :: v
            real :: t1, t2
            integer :: i, j, x, y

            img_out = img_in
            call cpu_time(t1)
            do y = TY / 2, H - TY
                do x = TX / 2, W - TX
                    do j = -TY / 2, TY / 2
                        do i = -TX / 2, TX / 2
                            v((j + TY / 2)*TX + i + TX / 2) = img_in((y -j)*W + x - i)
                        end do
                    end do

                    img_out(y*W + x) = f(v, TX*TY)
                end do
            end do
            call cpu_time(t2)
            print*, "Filter, C style method : ", t2 - t1, "s"    
        end subroutine processCStyle

        subroutine processMatrix(img_in, W, H, TX, TY, f, img_out)
            implicit none
            procedure(abstractfilter) :: f
            integer, intent(in) :: W, H, TX, TY
            real, dimension(0:W*H-1), intent(in) :: img_in
            real, dimension(0:W*H-1), intent(out) :: img_out

            real, dimension(TX, TY) :: v
            real, dimension(0:TX*TY-1) :: v_tmp
            real, dimension(0:H-1, 0:W-1) :: img 
            
            real :: t1, t2
            integer :: x, y

            img_out = img_in
            img = reshape(img_in, (/H, W/))

            call cpu_time(t1)
            do x = TX / 2, W - TX 
                do y = TY / 2, H - TY        
                    v = img(y-TY/2:y+TY/2, x-TX/2:x+TX/2)
                    v_tmp = reshape(v, (/TX*TY/))
                    img_out(x*W + y) = f(v, TX*TY) 
                    ! Here it's x*W+y because when Fortran use column-major order
                end do
            end do
            call cpu_time(t2)
            print*, "Filter, method with matrix: ", t2 - t1, "s"    
        end subroutine processMatrix

end module filterProcess

subroutine filter2d(img_in, W, H, TX, TY, method, img_out)
    use filterProcess
    use filters
    implicit none
    integer, intent(in) :: W, H, TX, TY, method
    real, dimension(1:W*H), intent(in) :: img_in
    real, dimension(1:W*H), intent(out) :: img_out

    if(method == 0) then
        call processCStyle(img_in, W, H, TX, TY, vmoy, img_out)
        call processMatrix(img_in, W, H, TX, TY, vmoy, img_out)
    else if(method == 1) then
        call processCStyle(img_in, W, H, TX, TY, vmin, img_out)
        call processMatrix(img_in, W, H, TX, TY, vmin, img_out)
    else if(method == 2) then
        call processCStyle(img_in, W, H, TX, TY, vmax, img_out)
        call processMatrix(img_in, W, H, TX, TY, vmax, img_out)
    else
        print*, "No method"
    end if

end subroutine filter2d