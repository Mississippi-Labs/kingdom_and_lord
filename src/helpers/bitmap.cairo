struct Bitmap{
    value: u64
}
#[generate_trait]
impl BitmapImpl of BitMapExtention{
    fn new() -> Bitmap {
        Bitmap { value: 0 }
    }

    // fn set(ref self: Bitmap, index: u8) {
    //     self.value |= 1 << index;
    // }

    // fn unset(ref self: Bitmap, index: u8) {
    //     self.value &= !(1 << index);
    // }

    // fn get(ref self: Bitmap, index: u8) -> bool {
    //     (self.value & (1 << index)) != 0
    // }
}


#[test]
fn test_bitmap(){
    let a:u64  = 2;
    let b:u64 =  2^4;

    let c: u64 = a & b;
    println!("{:?}, {}, {}", a, b, c);
}