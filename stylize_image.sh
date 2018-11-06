set -e
# Get a carriage return into `cr`
cr=`echo $'\n.'`
cr=${cr%.}

if [ "$#" -le 1 ]; then
   echo "Usage: bash stylize_image.sh <path_to_content_image> <path_to_style_image>"
   exit 1
fi

#echo ""
#read -p "Did you install the required dependencies? [y/n] $cr > " dependencies

#if [ "$dependencies" != "y" ]; then
#  echo "Error: Requires dependencies: tensorflow, opencv2 (python), scipy"
#  exit 1;
#fi

echo ""
read -p "Do you have a CUDA enabled GPU? [y/n] $cr > " cuda

if [ "$cuda" != "y" ]; then
  device='/cpu:0'
else
  device='/gpu:0'
fi

echo ""
read -p "Enter optimizer['lbfgs' or 'adam']: " optimizer

echo ""
read -p "Enter the color convertion type ['yuv', 'ycrcb', 'luv', 'lab']: " color_convert_type

echo ""
read -p "Image used to initialize the network ['random', 'content', 'style'] (default: content): " init_img_type

echo ""
read -p "Enter max-Size: " max_size

echo ""
read -p "Enter max-Iterations: " max_iterations

# Parse arguments
content_image="$1"
content_dir=$(dirname "$content_image")
content_filename=$(basename "$content_image")

style_image="$2"
style_dir=$(dirname "$style_image" )
style_filename=$(basename "$style_image")

echo "Rendering stylized image. This may take a while..."
python neural_style.py \
--content_img "${content_filename}" \
--content_img_dir "${content_dir}" \
--style_imgs "${style_filename}" \
--style_imgs_dir "${style_dir}" \
--device "${device}" \
--max_size "${max_size}" \
--max_iterations "${max_iterations}" \
--optimizer "${optimizer}" \
--color_convert_type "${color_convert_type}" \
--init_img_type "${init_img_type}" \
--verbose;
