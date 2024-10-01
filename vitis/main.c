#include "xil_io.h"
#include "xparameters.h"
#include "xuartlite_l.h"
//#include "xintc_l.h"
#include "xil_exception.h"

#include <stdint.h>
#include <stdio.h>
#include <math.h>

#define REG_OFFSET(n) ((n) * 4)

uint16_t coefficents[25] = {
#include "coeffs.txt"
};

static char buffer[32];
static volatile int received_data = 0;

void write_register (uint32_t base_address, int16_t reg, int32_t value) {
    Xil_Out32(base_address + REG_OFFSET(reg), value);
}

uint16_t read_register (uint32_t base_address, uint16_t reg) {
    return Xil_In32(base_address + REG_OFFSET(reg));
}

int32_t get_fixed_point_value(float coefficent, uint8_t fractional_bits)
{
    return (int32_t)(roundf(coefficent * (1 << fractional_bits)));
}

float get_float_from_fixed_point_value(int32_t fixed_point_value, uint8_t fractional_bits)
{
    return (float)fixed_point_value / (float)(1 << fractional_bits);
}

void uart_read_line(char* buffer, int max_len) {
    int i = 0;
    char c;
    // Processing untill new line character or buffer is full
    while (i < max_len - 1) {
        c = XUartLite_RecvByte(XPAR_AXI_UARTLITE_0_BASEADDR);
        if (c == '\n' || c == '\r') {
            break;
        }
        buffer[i++] = c;
    }
    buffer[i] = '\0';
}

float parse_coeff(const char *str)
{
    float result = 0.0;
    float factor = 1.0;

    // Handling sign
    if (*str == '-') {
        factor = -1.0;
        str++;
    }

    // Parsing integer part
    while (*str >= '0' && *str <= '9') {
        result = result * 10.0 + (*str - '0');
        str++;
    }

    // Parsing fractional part
    if (*str == '.') {
        float decimal_place = 0.1;
        str++;
        while (*str >= '0' && *str <= '9') {
            result += (*str - '0') * decimal_place;
            decimal_place *= 0.1;
            str++;
        }
    }
    return result * factor;
}


void handle_coeff_request(char* buffer, uint8_t size) {
    xil_printf("Setting coefficients\n\r" );

    float coeff;
    int32_t fixed_coeff;
    for (int8_t coeff_index = 0; coeff_index < 24; coeff_index++)
    {
        	uart_read_line(buffer, 32);
            // Loopback
            xil_printf("%s\n\r", buffer);
            // Parsing
            coeff = parse_coeff(buffer);
            // Converting to fixed point format
            fixed_coeff = get_fixed_point_value(coeff, 10);
            // Writing value
            write_register(XPAR_COEFFICENTS_REG_0_BASEADDR, coeff_index, fixed_coeff);
        }

    // Reading back and printing coefficients
    for (uint8_t i = 0; i < 25; i++)
    {
		// Reading back and converting
    	float val = get_float_from_fixed_point_value(read_register(XPAR_COEFFICENTS_REG_0_BASEADDR, i), 10);
    	int whole = (int)val;
    	int fraction = (int)((val - whole) * 10000);
        xil_printf("Eh%d: %d." ,i, whole );
        xil_printf("%d\r\n", fraction);
    }

}

void handle_histogram_request ()
{
    xil_printf("Histogram\n\r" );

    // Signaling to histogram module to start processing
	write_register(XPAR_HISTOGRAM_0_BASEADDR, 256, 1);

	// Delaying
	for (uint64_t delay = 0; delay < 2000000; delay++);
	uint32_t hist_val[256];
	for (uint16_t i = 0; i < 256; i++) {
		// Reading values
			hist_val[i] = read_register(XPAR_HISTOGRAM_0_BASEADDR, i);
	}
	for (uint16_t i = 0; i < 256; i++) {
		if (i < 255)
			xil_printf("%d,", hist_val[i]);
		else
			xil_printf("%d\n\r", hist_val[i]);
	}
}

int main() {
	for (int i = 0; i < 25; i++)
	{
		// Setting initial coefficients.
        write_register(XPAR_COEFFICENTS_REG_0_BASEADDR, i, coefficents[i]);
	}

	// Infinite cycle
    for (;;)
    {
    	// Reading prompt
        uart_read_line(buffer, 32);
        // Loopback
        xil_printf("%s\n", buffer);

        // Checking if prompt is valid, if yes calling handling function
        if (strcmp(buffer, "C") == 0)
        {
            handle_coeff_request(buffer, 32);
        }
        else if (strcmp(buffer, "H") == 0)
        {
            handle_histogram_request();
        }
    }
    return 0;
}
