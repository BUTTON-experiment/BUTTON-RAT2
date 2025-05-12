#include <Button.hh>
#include <RAT/AnyParse.hh>
#include <RAT/Rat.hh>
#include <iostream>
#include <string>

int main(int argc, char **argv) {
  auto parser = new RAT::AnyParse(argc, argv);
  auto button = BUTTON::Button(parser, argc, argv);
  button.Begin();
  button.Report();
}
