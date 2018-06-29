interface Instrument
{
  float getTop();
  float getLeft();
  float getHeight();
  float getWidth();
  void setCanvas(float x1, float y1, float x2, float y2);
  void draw(Note[] notes);
}